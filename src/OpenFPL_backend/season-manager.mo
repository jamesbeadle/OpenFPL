import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Timer "mo:base/Timer";
import TrieMap "mo:base/TrieMap";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Bool "mo:base/Bool";

import Account "lib/Account";
import DTOs "DTOs";
import Environment "utils/Environment";
import SHA224 "./lib/SHA224";
import SNSToken "sns-wrappers/ledger";
import T "types";
import Utilities "utils/utilities";

import ClubComposite "composites/club-composite";
import LeaderboardComposite "composites/leaderboard-composite";
import ManagerComposite "composites/manager-composite";
import PlayerComposite "composites/player-composite";
import PrivateLeaguesManager "private-leagues-manager";
import SeasonComposite "composites/season-composite";

module {

  public class SeasonManager() {

    //Setup functions and references

    private var setAndBackupTimer : ?((duration : Timer.Duration, callbackName : Text) -> async ()) = null;
    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    private var recordSystemEvent : ?((eventLog: T.EventLogEntry) -> ()) = null;

    public func setTimerBackupFunction(
      _setAndBackupTimer : (duration : Timer.Duration, callbackName : Text) -> async (),
      _removeExpiredTimers : () -> (),
    ) {
      playerComposite.setTimerBackupFunction(_setAndBackupTimer, _removeExpiredTimers);
      setAndBackupTimer := ?_setAndBackupTimer;
    };

    public func setStoreCanisterIdFunction(_storeCanisterId : (canisterId : Text) -> async ()) {
      managerComposite.setStoreCanisterIdFunction(_storeCanisterId);
      leaderboardComposite.setStoreCanisterIdFunction(_storeCanisterId);
      storeCanisterId := ?_storeCanisterId;
    };

    public func setRecordSystemEventFunction(_recordSystemEvent : (eventLog: T.EventLogEntry) -> ()) {
      managerComposite.setRecordSystemEventFunction(_recordSystemEvent);
      leaderboardComposite.setRecordSystemEventFunction(_recordSystemEvent);
      recordSystemEvent := ?_recordSystemEvent;
    };

    public func setBackendCanisterController(controller : Principal) {
      leaderboardComposite.setBackendCanisterController(controller);
      privateLeaguesManager.setBackendCanisterController(controller);
    };


    //System state variables

    private var systemState : T.SystemState = {
      calculationGameweek = 1;
      calculationMonth = 8;
      calculationSeasonId = 1;
      pickTeamGameweek = 1;
      pickTeamSeasonId = 1;
      seasonActive = false;
      transferWindowActive = false;
      onHold = false;
    };

    public func getSystemState() : DTOs.SystemStateDTO {
      let pickTeamSeason = seasonComposite.getSeason(systemState.pickTeamSeasonId);
      let calculationSeason = seasonComposite.getSeason(systemState.calculationSeasonId);
      var pickTeamSeasonName = "";
      var calculationSeasonName = "";
      switch (pickTeamSeason) {
        case (null) {};
        case (?foundSeason) {
          pickTeamSeasonName := foundSeason.name;
        };
      };
      switch (calculationSeason) {
        case (null) {};
        case (?foundSeason) {
          calculationSeasonName := foundSeason.name;
        };
      };
      return {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamSeasonName = pickTeamSeasonName;
        calculationSeasonName = calculationSeasonName;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
        seasonActive = systemState.seasonActive;
      };
    };


    //Data cache variables

    private var dataCacheHashes : List.List<T.DataCache> = List.fromArray([
      { category = "clubs"; hash = "OPENFPL_1" },
      { category = "fixtures"; hash = "OPENFPL_1" },
      { category = "weekly_leaderboard"; hash = "OPENFPL_1" },
      { category = "monthly_leaderboards"; hash = "OPENFPL_1" },
      { category = "season_leaderboard"; hash = "OPENFPL_1" },
      { category = "players"; hash = "OPENFPL_1" },
      { category = "player_events"; hash = "OPENFPL_1" },
      { category = "countries"; hash = "OPENFPL_1" },
      { category = "system_state"; hash = "OPENFPL_1" },
    ]);

    public func getDataHashes() : [DTOs.DataCacheDTO] {
      return List.toArray(dataCacheHashes);
    };

    public func updateCacheHash(category : Text) : async () {
      let hashBuffer = Buffer.fromArray<T.DataCache>([]);

      for (hashObj in Iter.fromList(dataCacheHashes)) {
        if (hashObj.category == category) {
          let randomHash = await SHA224.getRandomHash();
          hashBuffer.add({ category = hashObj.category; hash = randomHash });
        } else { hashBuffer.add(hashObj) };
      };

      dataCacheHashes := List.fromArray(Buffer.toArray<T.DataCache>(hashBuffer));
    };


    //Game composites & structures

    let managerComposite = ManagerComposite.ManagerComposite();
    let playerComposite = PlayerComposite.PlayerComposite();
    let clubComposite = ClubComposite.ClubComposite();
    let seasonComposite = SeasonComposite.SeasonComposite();
    let leaderboardComposite = LeaderboardComposite.LeaderboardComposite();
    let privateLeaguesManager = PrivateLeaguesManager.PrivateLeaguesManager();

    var rewardPools : TrieMap.TrieMap<T.SeasonId, T.RewardPool> = TrieMap.TrieMap<T.SeasonId, T.RewardPool>(Utilities.eqNat16, Utilities.hashNat16);


    //Game getters

    public func getFixtures(dto: DTOs.GetFixturesDTO) : [DTOs.FixtureDTO] {
      return seasonComposite.getFixtures(dto);
    };

    public func getSeasons() : [DTOs.SeasonDTO] {
      return seasonComposite.getSeasons();
    };

    public func getPostponedFixtures() : [DTOs.FixtureDTO] {
      return seasonComposite.getPostponedFixtures(systemState.calculationSeasonId);
    };

    public func getPlayers() : [DTOs.PlayerDTO] {
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      return playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
    };

    public func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : [DTOs.PlayerDTO] {
      return playerComposite.getLoanedPlayers(dto);
    };

    public func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : [DTOs.PlayerDTO] {
      return playerComposite.getRetiredPlayers(dto);
    };

    public func getClubs() : [DTOs.ClubDTO] {
      return clubComposite.getClubs();
    };

    public func getFormerClubs() : [DTOs.ClubDTO] {
      return clubComposite.getFormerClubs();
    };

    public func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : [DTOs.PlayerPointsDTO] {
      return playerComposite.getPlayerDetailsForGameweek(dto);
    };

    public func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : DTOs.PlayerDetailDTO {
      return playerComposite.getPlayerDetails(dto);
    };

    public func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : [(Nat16, DTOs.PlayerScoreDTO)] {
      let result = playerComposite.getPlayersMap(dto);
      return result;
    };

    public func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getWeeklyLeaderboard(dto);
    };

    public func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getMonthlyLeaderboard(dto);
    };

    public func getMonthlyLeaderboards(dto: DTOs.GetMonthlyLeaderboardsDTO) : async Result.Result<[DTOs.ClubLeaderboardDTO], T.Error> {
      let clubs = clubComposite.getClubs();
      return await leaderboardComposite.getMonthlyLeaderboards(dto, clubs);
    };

    public func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getSeasonLeaderboard(dto);
    };

    public func getProfile(principalId : Text) : async Result.Result<DTOs.ProfileDTO, T.Error> {
      return await managerComposite.getProfile(principalId);
    };

    public func getCurrentTeam(principalId : Text) : async Result.Result<DTOs.PickTeamDTO, T.Error> {
      return await managerComposite.getCurrentTeam(principalId);
    };

    public func getManagerUsername(principalId: Text) : ?Text {
      return managerComposite.getManagerUsername(principalId);
    };

    public func getManagerCanisterId(principalId: Text) : ?T.CanisterId {
      return managerComposite.getManagerCanisterId(principalId);  
    };

    public func getManager(dto: DTOs.GetManagerDTO) : async Result.Result<DTOs.ManagerDTO, T.Error> {

      let weeklyLeaderboardEntry = await leaderboardComposite.getWeeklyLeaderboardEntry(dto.managerId, systemState.calculationSeasonId, systemState.calculationGameweek);

      var managerFavouriteClub : T.ClubId = 0;
      let result = await managerComposite.getFavouriteClub(dto.managerId);
      switch (result) {
        case (#ok(favouriteClubId)) {
          managerFavouriteClub := favouriteClubId;
        };
        case _ {};
      };
      var monthlyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO = null;
      if (managerFavouriteClub > 0) {
        monthlyLeaderboardEntry := await leaderboardComposite.getMonthlyLeaderboardEntry(dto.managerId, systemState.calculationSeasonId, systemState.calculationMonth, managerFavouriteClub);
      };

      let seasonLeaderboardEntry = await leaderboardComposite.getSeasonLeaderboardEntry(dto.managerId, systemState.calculationSeasonId);

      return await managerComposite.getManager(dto.managerId, systemState.calculationSeasonId, weeklyLeaderboardEntry, monthlyLeaderboardEntry, seasonLeaderboardEntry);
    };

    public func getManagerByUsername(username: Text) : async Result.Result<DTOs.ManagerDTO, T.Error> {
      return await managerComposite.getManagerByUsername(username);
    };

    public func getTotalManagers() : Nat {
      return managerComposite.getTotalManagers();
    };

    public func isUsernameValid(dto: DTOs.UsernameFilterDTO) : Bool {
      return managerComposite.isUsernameValid(dto.username);
    };

    public func isUsernameTaken(dto: DTOs.UsernameFilterDTO, principalId : Text) : Bool {
      return managerComposite.isUsernameTaken(dto.username, principalId);
    };

    public func searchByUsername(username : Text) : async ?DTOs.ManagerDTO {
      return await managerComposite.searchByUsername(username);
    };

    //Game update functions

    public func saveFantasyTeam(principalId: T.PrincipalId, updatedFantasyTeam : DTOs.UpdateTeamSelectionDTO) : async Result.Result<(), T.Error> {
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
      return await managerComposite.saveFantasyTeam(principalId, updatedFantasyTeam, systemState, players);
    };

    public func updateUsername(principalId : Text, updatedUsername : Text) : async Result.Result<(), T.Error> {
      return await managerComposite.updateUsername(principalId, updatedUsername, systemState);
    };

    public func updateFavouriteClub(principalId : Text, clubId : T.ClubId) : async Result.Result<(), T.Error> {
      let allClubs = clubComposite.getClubs();
      return await managerComposite.updateFavouriteClub(principalId, clubId, systemState, allClubs);
    };

    public func updateProfilePicture(principalId: T.PrincipalId, dto: DTOs.UpdateProfilePictureDTO) : async Result.Result<(), T.Error> {
      return await managerComposite.updateProfilePicture(principalId, dto, systemState);
    };


    //Timer call back events

    public func gameweekBeginExpired() : async () {

      var pickTeamGameweek : T.GameweekNumber = 1;
      if (systemState.pickTeamGameweek < 38) {
        pickTeamGameweek := systemState.pickTeamGameweek + 1;
      };

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        transferWindowActive = systemState.transferWindowActive;
        seasonActive = true;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      logSystemStatus();
      
      await managerComposite.snapshotFantasyTeams(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth);
      await updateCacheHash("system_state");
    };

    private func logSystemStatus(){
        switch(recordSystemEvent){
          case null{};
          case (?function){
            function({
              eventDetail = 
                "System Status Updated: Calculation Gameweek: " # Nat8.toText(systemState.calculationGameweek) 
                  # ", Pick Team Gameweek: " # Nat8.toText(systemState.calculationMonth) 
                  # ", Pick Team Gameweek: " # Nat16.toText(systemState.calculationSeasonId) 
                  # ", Pick Team Gameweek: " # Nat8.toText(systemState.pickTeamGameweek) 
                  # ", Pick Team Gameweek: " # Nat16.toText(systemState.pickTeamSeasonId) 
                  # ", Pick Team Gameweek: " # Bool.toText(systemState.transferWindowActive) 
                  # ", Pick Team Gameweek: " # Bool.toText(systemState.seasonActive) 
                  # ", Pick Team Gameweek: " # Bool.toText(systemState.onHold) # "."; 
              eventId = 0;
              eventTime = Time.now();
              eventTitle = "Canister Topup";
              eventType = #SystemCheck;
            });
          }
      };

    };

    public func gameKickOffExpiredCallback() : async () {
      seasonComposite.setFixturesToActive(systemState.calculationSeasonId);
      await updateCacheHash("fixtures");
    };

    public func gameCompletedExpiredCallback() : async () {
      seasonComposite.setFixturesToCompleted(systemState.calculationSeasonId);

      let seasonFixtures = seasonComposite.getFixtures({seasonId = systemState.pickTeamSeasonId});
      
      let incompleteFixtures = Array.find<DTOs.FixtureDTO>(
        seasonFixtures,
        func(fixture : DTOs.FixtureDTO) : Bool {
              return fixture.status != #Complete;
        },
      );

      if(Option.isNull(incompleteFixtures)){
        systemState := {
          calculationGameweek = systemState.calculationGameweek;
          calculationMonth = systemState.calculationMonth;
          calculationSeasonId = systemState.calculationSeasonId;
          pickTeamGameweek = systemState.pickTeamGameweek;
          pickTeamSeasonId = systemState.pickTeamSeasonId;
          seasonActive = false;
          transferWindowActive = systemState.seasonActive;
          onHold = systemState.onHold;
        };
      };
      logSystemStatus();
      
      await updateCacheHash("fixtures");
    };

    public func loanExpiredCallback() : async () {
      await playerComposite.loanExpired();
      await updateCacheHash("players");
    };

    public func injuryExpiredCallback() : async () {
      await playerComposite.injuryExpired();
      await updateCacheHash("players");
    };

    public func transferWindowStartCallback() : async () {
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        seasonActive = systemState.seasonActive;
        transferWindowActive = true;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      logSystemStatus();
      await updateCacheHash("system_state");
    };

    public func transferWindowEndCallback() : async () {
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        seasonActive = systemState.seasonActive;
        transferWindowActive = false;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      logSystemStatus();
      await updateCacheHash("system_state");
    };


    //In game system functions

    private func incrementCalculationGameweek() : async () {
    
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek + 1;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      logSystemStatus();
    };

    private func incrementCalculationMonth() : async () {
      
      var month = systemState.calculationMonth;
      if (month == 12) {
        month := 1;
      } else {
        month := month + 1;
      };

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = month;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      logSystemStatus();
    };

    private func incrementCalculationSeason() : async () {
      
      var seasonId = systemState.calculationSeasonId;
      
      var nextSeasonId = seasonId + 1;
      seasonComposite.setStableNextSeasonId(nextSeasonId);

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = nextSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      logSystemStatus();
    };

    private func setTransferWindowTimers() : async () {
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {

          let jan1Date = Utilities.nextUnixTimeForDayOfYear(1);
          let jan31Date = Utilities.nextUnixTimeForDayOfYear(31);

          let transferWindowStartDate : Timer.Duration = #nanoseconds(Int.abs(jan1Date - Time.now()));
          let transferWindowEndDate : Timer.Duration = #nanoseconds(Int.abs(jan31Date - Time.now()));

          await actualFunction(transferWindowStartDate, "transferWindowStart");
          await actualFunction(transferWindowEndDate, "transferWindowEnd");
        };
      };
    };

    public func setGameweekTimers(gameweek: T.GameweekNumber) : async () {
      let fixtures = seasonComposite.getFixtures({seasonId = systemState.calculationSeasonId});
      let filteredFilters = Array.filter<DTOs.FixtureDTO>(
        fixtures,
        func(fixture : DTOs.FixtureDTO) : Bool {
          return fixture.gameweek == gameweek;
        },
      );

      let sortedArray = Array.sort(
        filteredFilters,
        func(a : DTOs.FixtureDTO, b : DTOs.FixtureDTO) : Order.Order {
          if (a.kickOff < b.kickOff) { return #less };
          if (a.kickOff == b.kickOff) { return #equal };
          return #greater;
        },
      );

      let firstFixture = sortedArray[0];
      let durationToHourBeforeFirstFixture : Timer.Duration = #nanoseconds(Int.abs(firstFixture.kickOff - Utilities.getHour() - Time.now()));
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(durationToHourBeforeFirstFixture, "gameweekBeginExpired");
        };
      };

      await setKickOffTimers(filteredFilters);
    };

    private func setKickOffTimers(gameweekFixtures : [DTOs.FixtureDTO]) : async () {
      for (fixture in Iter.fromArray(gameweekFixtures)) {
        switch (setAndBackupTimer) {
          case (null) {};
          case (?actualFunction) {
            let durationToKickOff : Timer.Duration = #nanoseconds(Int.abs(fixture.kickOff - Time.now()));
            await actualFunction(durationToKickOff, "gameKickOffExpired");

            let durationToEndOfGame : Timer.Duration = #nanoseconds(Int.abs(fixture.kickOff - Time.now() + (Utilities.getHour() * 2)));
            await actualFunction(durationToEndOfGame, "gameCompletedExpired");
          };
        };
      };
    };


    //Reward function
    
    private func calculateRewardPool(seasonId : T.SeasonId) : async () {

      let ledger : SNSToken.Interface = actor (Environment.SNS_LEDGER_CANISTER_ID);
      
      let totalSupply : Nat64 = Nat64.fromNat(await ledger.icrc1_total_supply());

      let seasonTokensMinted = Utilities.nat64Percentage(totalSupply, 0.01875);

      let rewardPool : T.RewardPool = {
        seasonId = seasonId;
        seasonLeaderboardPool = Utilities.nat64Percentage(seasonTokensMinted, 0.3);
        monthlyLeaderboardPool = Utilities.nat64Percentage(seasonTokensMinted, 0.2);
        weeklyLeaderboardPool = Utilities.nat64Percentage(seasonTokensMinted, 0.15);
        mostValuableTeamPool = Utilities.nat64Percentage(seasonTokensMinted, 0.1);
        highestScoringMatchPlayerPool = Utilities.nat64Percentage(seasonTokensMinted, 0.1);
        allTimeWeeklyHighScorePool = Utilities.nat64Percentage(seasonTokensMinted, 0.05);
        allTimeMonthlyHighScorePool = Utilities.nat64Percentage(seasonTokensMinted, 0.05);
        allTimeSeasonHighScorePool = Utilities.nat64Percentage(seasonTokensMinted, 0.05);
      };

      rewardPools.put(seasonId, rewardPool);
    };

    private func payWeeklyRewards(rewardPool : T.RewardPool) : async () {
      let weeklyLeaderboardCanisterId = await leaderboardComposite.getWeeklyCanisterId(systemState.calculationSeasonId, systemState.calculationGameweek);
      switch (weeklyLeaderboardCanisterId) {
        case (null) {};
        case (?canisterId) {
          let weekly_leaderboard_canister = actor (canisterId) : actor {
            getRewardLeaderboard : () -> async ?DTOs.WeeklyLeaderboardDTO;
          };

          let weeklyLeaderboard = await weekly_leaderboard_canister.getRewardLeaderboard();
          switch(weeklyLeaderboard){
            case (null){

            };
            case (?foundLeaderboard){
              let fixtures = seasonComposite.getFixtures({seasonId = systemState.calculationSeasonId});
              let gameweekFixtures = Array.filter<DTOs.FixtureDTO>(
                fixtures,
                func(fixture : DTOs.FixtureDTO) : Bool {
                  return fixture.gameweek == foundLeaderboard.gameweek;
                },
              );
              await managerComposite.payWeeklyRewards(rewardPool, foundLeaderboard, { seasonId = systemState.calculationSeasonId; gameweek = systemState.calculationGameweek }, List.fromArray(gameweekFixtures));
              
            }
          };
        };
      };
    };

    private func payMonthlyRewards(rewardPool : T.RewardPool) : async () {
      
      let clubs = clubComposite.getClubs();
      for (club in Iter.fromArray(clubs)) {
        let monthlyLeaderboardCanisterId = await leaderboardComposite.getMonthlyCanisterId(systemState.calculationSeasonId, systemState.calculationMonth, club.id);
        switch (monthlyLeaderboardCanisterId) {
          case (null) {};
          case (?canisterId) {
            let monthly_leaderboard_canister = actor (canisterId) : actor {
              getRewardLeaderboard : () -> async ?DTOs.ClubLeaderboardDTO;
            };

            let monthlyLeaderboard = await monthly_leaderboard_canister.getRewardLeaderboard();
            switch(monthlyLeaderboard){
              case (null){

              };
              case (?foundLeaderboard){
                await managerComposite.payMonthlyRewards(rewardPool, foundLeaderboard);
              }
            };
          };
        };
      };
    };

    private func paySeasonRewards(rewardPool : T.RewardPool) : async () {
      let seasonLeaderboardCanisterId = await leaderboardComposite.getSeasonCanisterId(systemState.calculationSeasonId);
      switch (seasonLeaderboardCanisterId) {
        case (null) {};
        case (?canisterId) {
          let season_leaderboard_canister = actor (canisterId) : actor {
            getRewardLeaderboard : () -> async ?DTOs.SeasonLeaderboardDTO;
          };
          let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
            return club.id;
          });
          let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
          let seasonLeaderboard = await season_leaderboard_canister.getRewardLeaderboard();
          switch(seasonLeaderboard){
            case (null){

            };
            case (?foundLeaderboard){
              await managerComposite.paySeasonRewards(rewardPool, foundLeaderboard, players, systemState.calculationSeasonId);
            }
          };
        };
      };
    };

    
    //Governance validation and execution functions

    public func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : T.RustResult {
      let clubs = clubComposite.getClubs();
      return seasonComposite.validateAddInitialFixtures(addInitialFixturesDTO, clubs);
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async () {

      await seasonComposite.executeAddInitialFixtures(addInitialFixturesDTO);

      let sortedArray = Array.sort(
        addInitialFixturesDTO.seasonFixtures,
        func(a : DTOs.FixtureDTO, b : DTOs.FixtureDTO) : Order.Order {
          if (a.kickOff < b.kickOff) { return #less };
          if (a.kickOff == b.kickOff) { return #equal };
          return #greater;
        },
      );
      let firstFixture = sortedArray[0];

      let updatedSystemState : T.SystemState = {
        calculationGameweek = 1;
        calculationMonth = Utilities.unixTimeToMonth(firstFixture.kickOff);
        calculationSeasonId = addInitialFixturesDTO.seasonId;
        pickTeamSeasonId = addInitialFixturesDTO.seasonId;
        pickTeamGameweek = 1;
        seasonActive = false;
        transferWindowActive = true;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      logSystemStatus();

      await setGameweekTimers(1);
      await updateCacheHash("fixtures");
    };

    public func validateSubmitFixtureData(submitFixtureDataDTO : DTOs.SubmitFixtureDataDTO) : T.RustResult {
      return seasonComposite.validateSubmitFixtureData(submitFixtureDataDTO);
    };

    public func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
      let populatedPlayerEvents = await seasonComposite.populatePlayerEventData(submitFixtureData, players);
      switch (populatedPlayerEvents) {
        case (null) {};
        case (?events) {
          await playerComposite.addEventsToPlayers(events, submitFixtureData.seasonId, submitFixtureData.gameweek);
          await seasonComposite.addEventsToFixture(events, submitFixtureData.seasonId, submitFixtureData.fixtureId);
        };
      };

      let playerPointsMap = playerComposite.getPlayersMap({ seasonId = systemState.calculationSeasonId; gameweek = systemState.calculationGameweek });

      await managerComposite.calculateFantasyTeamScores(playerPointsMap, systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth);
      await leaderboardComposite.calculateLeaderboards(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth, managerComposite.getStableUniqueManagerCanisterIds());
      
      //await privateLeaguesManager.calculateLeaderboards(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth);
      
      let rewardPool = rewardPools.get(systemState.calculationSeasonId);
      switch (rewardPool) {
        case (null) {};
        case (?foundRewardPool) {

          let gameweekComplete = seasonComposite.checkGameweekComplete(systemState);
          let monthComplete = seasonComposite.checkMonthComplete(systemState);
          let seasonComplete = seasonComposite.checkSeasonComplete(systemState);

          if(gameweekComplete){
            await managerComposite.resetWeeklyTransfers();
            await payWeeklyRewards(foundRewardPool);
            //await privateLeaguesManager.payWeeklyRewards({ seasonId = systemState.calculationSeasonId; gameweek = systemState.calculationGameweek });
            await incrementCalculationGameweek();
            await setGameweekTimers(systemState.calculationGameweek);
          };

          if(monthComplete){
            await managerComposite.resetBonusesAvailable();
            await payMonthlyRewards(foundRewardPool);
            //await privateLeaguesManager.payMonthlyRewards(systemState.calculationSeasonId, systemState.calculationMonth);
            await incrementCalculationMonth();
          };

          if(seasonComplete){
            await managerComposite.resetFantasyTeams(seasonComposite.getStableNextSeasonId());
            await paySeasonRewards(foundRewardPool);
            //await privateLeaguesManager.paySeasonRewards(systemState.calculationSeasonId);
            await incrementCalculationSeason();
            
            seasonComposite.createNewSeason(systemState);
              
            let currentSeasonId = seasonComposite.getStableNextSeasonId();
            await calculateRewardPool(currentSeasonId);
            
            await setTransferWindowTimers();
          };

        };
      };
      
      await updateCacheHash("players");
      await updateCacheHash("player_events");
      await updateCacheHash("fixtures");
      await updateCacheHash("weekly_leaderboard");
      await updateCacheHash("monthly_leaderboards");
      await updateCacheHash("season_leaderboard");
      await updateCacheHash("system_state");
    };

    public func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : T.RustResult {
      return seasonComposite.validateMoveFixture(moveFixtureDTO, systemState);
    };

    public func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async () {
      await seasonComposite.executeMoveFixture(moveFixtureDTO, systemState);
      await updateCacheHash("fixtures");
    };

    public func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : T.RustResult {
      return seasonComposite.validatePostponeFixture(postponeFixtureDTO, systemState);
    };

    public func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async () {
      await seasonComposite.executePostponeFixture(postponeFixtureDTO, systemState);
      await updateCacheHash("fixtures");
    };

    public func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : T.RustResult {
      return seasonComposite.validateRescheduleFixture(rescheduleFixtureDTO, systemState);
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async () {
      await seasonComposite.executeRescheduleFixture(rescheduleFixtureDTO, systemState);
      await updateCacheHash("fixtures");
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : T.RustResult {
      if(not systemState.seasonActive){
        return #Err("Season not active.");
      };
      return playerComposite.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async () {
      await playerComposite.executeRevaluePlayerUp(revaluePlayerUpDTO, systemState);
      await updateCacheHash("players");
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : T.RustResult {
      if(not systemState.seasonActive){
        return #Err("Season not active.");
      };
      return playerComposite.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async () {
      await playerComposite.executeRevaluePlayerDown(revaluePlayerDownDTO, systemState);
      await updateCacheHash("players");
    };

    public func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : T.RustResult {
      let clubs = clubComposite.getClubs();
      return playerComposite.validateLoanPlayer(loanPlayerDTO, List.fromArray(clubs));
    };

    public func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async () {
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
      await managerComposite.removePlayerFromTeams(loanPlayerDTO.playerId, players);
      await playerComposite.executeLoanPlayer(loanPlayerDTO, systemState);
      await updateCacheHash("players");
    };

    public func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : T.RustResult {
      let clubs = clubComposite.getClubs();
      return playerComposite.validateTransferPlayer(transferPlayerDTO, List.fromArray(clubs));
    };

    public func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async () {
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
      await managerComposite.removePlayerFromTeams(transferPlayerDTO.playerId, players);
      await playerComposite.executeTransferPlayer(transferPlayerDTO, systemState);
      await updateCacheHash("players");
    };

    public func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : T.RustResult {
      return playerComposite.validateRecallPlayer(recallPlayerDTO);
    };

    public func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async () {
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
      await managerComposite.removePlayerFromTeams(recallPlayerDTO.playerId, players);
      await playerComposite.executeRecallPlayer(recallPlayerDTO);
      await updateCacheHash("players");
    };

    public func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : T.RustResult {
      let clubs = clubComposite.getClubs();
      return playerComposite.validateCreatePlayer(createPlayerDTO, List.fromArray(clubs));
    };

    public func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async () {
      await playerComposite.executeCreatePlayer(createPlayerDTO);
      await updateCacheHash("players");
    };

    public func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : T.RustResult {
      return playerComposite.validateUpdatePlayer(updatePlayerDTO);
    };

    public func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async () {
      let currentPlayerPosition = playerComposite.getPlayerPosition(updatePlayerDTO.playerId);
      await playerComposite.executeUpdatePlayer(updatePlayerDTO);
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);

      switch (currentPlayerPosition) {
        case (null) { return };
        case (?foundPosition) {
          if (foundPosition != updatePlayerDTO.position) {
            await managerComposite.removePlayerFromTeams(updatePlayerDTO.playerId, players);
          };

          await updateCacheHash("players");
        };
      };
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : T.RustResult {
      return playerComposite.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async () {
      await playerComposite.executeSetPlayerInjury(setPlayerInjuryDTO);
      await updateCacheHash("players");
    };

    public func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : T.RustResult {
      return playerComposite.validateRetirePlayer(retirePlayerDTO);
    };

    public func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async () {
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
      await managerComposite.removePlayerFromTeams(retirePlayerDTO.playerId, players);
      await playerComposite.executeRetirePlayer(retirePlayerDTO);
      await updateCacheHash("players");
    };

    public func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : T.RustResult {
      return playerComposite.validateUnretirePlayer(unretirePlayerDTO);
    };

    public func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async () {
      await playerComposite.executeUnretirePlayer(unretirePlayerDTO);
      await updateCacheHash("players");
    };

    public func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : T.RustResult {
      return clubComposite.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public func executePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async () {
      await clubComposite.executePromoteFormerClub(promoteFormerClubDTO);
      await updateCacheHash("clubs");
    };

    public func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : T.RustResult {
      return clubComposite.validatePromoteNewClub(promoteNewClubDTO);
    };

    public func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async () {
      await clubComposite.executePromoteNewClub(promoteNewClubDTO);
      await updateCacheHash("clubs");
    };

    public func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : T.RustResult {
      return clubComposite.validateUpdateClub(updateClubDTO);
    };

    public func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async () {
      await clubComposite.executeUpdateClub(updateClubDTO);
      await updateCacheHash("clubs");
    };

    //Private league functions

    public func isPrivateLeagueMember(canisterId: T.CanisterId, callerId: T.PrincipalId) : async Bool {
      return await privateLeaguesManager.isLeagueMember(canisterId, callerId);
    };
    
    public func getPrivateLeagueWeeklyLeaderboard(dto: DTOs.GetPrivateLeagueWeeklyLeaderboard) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      await privateLeaguesManager.getWeeklyLeaderboard(dto);
    };  

    public func getPrivateLeagueMonthlyLeaderboard(dto: DTOs.GetPrivateLeagueMonthlyLeaderboard) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      await privateLeaguesManager.getMonthlyLeaderboard(dto);
    };

    public func getPrivateLeagueSeasonLeaderboard(dto: DTOs.GetPrivateLeagueSeasonLeaderboard) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      await privateLeaguesManager.getSeasonLeaderboard(dto)
    };
    
    public func getPrivateLeagueMembers(dto: DTOs.GetLeagueMembersDTO) : async Result.Result<[DTOs.LeagueMemberDTO], T.Error> {
      await privateLeaguesManager.getLeagueMembers(dto);
    };

    public func privateLeagueIsValid(privateLeague: DTOs.CreatePrivateLeagueDTO) : Bool{
      return privateLeaguesManager.privateLeagueIsValid(privateLeague);
    };

    public func createPrivateLeague(defaultAccount: Principal, managerId: Principal, newPrivateLeague: DTOs.CreatePrivateLeagueDTO) : async Result.Result<(), T.Error> {
      return await privateLeaguesManager.createPrivateLeague(defaultAccount, managerId, newPrivateLeague);
    };

    public func nameAvailable(privateLeagueName: Text) : Bool{
      return privateLeaguesManager.nameAvailable(privateLeagueName);
    };

    public func leagueHasSpace(canisterId: T.CanisterId) : async Bool {
      return await privateLeaguesManager.leagueHasSpace(canisterId);
    };

    public func isLeagueMember(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Bool {
      return await privateLeaguesManager.isLeagueMember(canisterId, managerId);
    };

    public func isLeagueAdmin(canisterId: T.CanisterId, principalId: T.PrincipalId) : async Bool {
      return await privateLeaguesManager.isLeagueAdmin(canisterId, principalId);
    };

    public func inviteUserToLeague(dto: DTOs.LeagueInviteDTO, callerId: T.PrincipalId) : async Result.Result<(), T.Error> {
      return await privateLeaguesManager.inviteUserToLeague(dto, callerId);
    };

    public func acceptLeagueInvite(canisterId: T.CanisterId, managerId: T.PrincipalId) : async Result.Result<(), T.Error> {
      let manager = await getManager({managerId = managerId});
      switch(manager){
        case (#ok foundManager){
          return await privateLeaguesManager.acceptLeagueInvite(canisterId, managerId, foundManager.username);
        };
        case _ {};
      };
      return #err(#NotFound);
    };

    public func updateLeaguePicture(dto: DTOs.UpdateLeaguePictureDTO) : async Result.Result<(), T.Error> {
      return await privateLeaguesManager.updateLeaguePicture(dto);
    };

    public func updateLeagueBanner(dto: DTOs.UpdateLeagueBannerDTO) : async Result.Result<(), T.Error> {
      return await privateLeaguesManager.updateLeagueBanner(dto);
    };

    public func updateLeagueName(dto: DTOs.UpdateLeagueNameDTO) : async Result.Result<(), T.Error> {
      return await privateLeaguesManager.updateLeagueName(dto);
    };

    public func getPrivateLeague(canisterId: T.CanisterId) : async Result.Result<DTOs.PrivateLeagueDTO, T.Error> {
      return await privateLeaguesManager.getPrivateLeague(canisterId);
    };

    public func enterLeague(canisterId: T.CanisterId, managerId: T.PrincipalId, managerCanisterId: T.CanisterId, username: Text) : async Result.Result<(), T.Error> {
      return await privateLeaguesManager.enterLeague(canisterId, managerId, managerCanisterId, username);
    };

    public func inviteExists(canisterId: T.CanisterId, managerId: T.PrincipalId) :  async Bool {
      return await privateLeaguesManager.inviteExists(canisterId, managerId);
    };

    public func leagueExists(privateLeagueCanisterId: T.CanisterId) : Bool {
      return privateLeaguesManager.leagueExists(privateLeagueCanisterId);
    };

    public func payPrivateLeagueReward(defaultAccount: Principal, privateLeagueCanisterId: T.CanisterId, tokens: [T.TokenInfo], winnerPrincipal: T.PrincipalId, amount: Nat64) : async () {
      
      let privateLeague = await getPrivateLeague(privateLeagueCanisterId);

      switch(privateLeague){
        case (#ok foundPrivateLeague){

          var tokenCanisterId = "";
          var tokenTransactionFee: Nat = 0;
          for(token in Iter.fromArray(tokens)){
            if(token.id == foundPrivateLeague.tokenId){
              tokenCanisterId := token.canisterId;
              tokenTransactionFee := token.fee;
            }
          };

          if(tokenCanisterId == ""){
            return;
          };
      
          let ledger : SNSToken.Interface = actor (tokenCanisterId);
            
          let _ = await ledger.icrc1_transfer ({
            memo = ?Text.encodeUtf8("0");
              from_subaccount = ?Account.principalToSubaccount(Principal.fromText(tokenCanisterId));
              to = { owner = defaultAccount; subaccount = ?Account.principalToSubaccount(Principal.fromText(winnerPrincipal)) };
              amount = Nat64.toNat(amount);
              fee = ?tokenTransactionFee;
              created_at_time = ?Nat64.fromNat(Int.abs(Time.now()))
          });
          
        };
        case (_){ };
      };
    };

    //Stable data getters and setters:

    public func getStableRewardPools() : [(T.SeasonId, T.RewardPool)] {
      Iter.toArray(rewardPools.entries());
    };

    public func setStableRewardPools(stable_reward_pools : [(T.SeasonId, T.RewardPool)]) {
      rewardPools := TrieMap.fromEntries<T.SeasonId, T.RewardPool>(
        Iter.fromArray(stable_reward_pools),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    };

    public func getStableSystemState() : T.SystemState {
      return systemState;
    };

    public func setStableSystemState(stable_system_state : T.SystemState) {
      systemState := stable_system_state;
    };

    public func getStableManagerCanisterIds() : [(T.PrincipalId, T.CanisterId)] {
      return managerComposite.getStableManagerCanisterIds();
    };

    public func setStableManagerCanisterIds(stable_manager_canister_ids : [(T.PrincipalId, T.CanisterId)]) {
      managerComposite.setStableManagerCanisterIds(stable_manager_canister_ids);
    };

    public func getStableManagerUsernames() : [(T.PrincipalId, Text)] {
      return managerComposite.getStableManagerUsernames();
    };

    public func setStableManagerUsernames(stable_manager_usernames : [(T.PrincipalId, Text)]) {
      managerComposite.setStableManagerUsernames(stable_manager_usernames);
    };

    public func getStableUniqueManagerCanisterIds() : [T.CanisterId] {
      return managerComposite.getStableUniqueManagerCanisterIds();
    };

    public func setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids : [T.CanisterId]) {
      managerComposite.setStableUniqueManagerCanisterIds(stable_unique_manager_canister_ids);
    };

    public func getStableTotalManagers() : Nat {
      return managerComposite.getStableTotalManagers();
    };

    public func setStableTotalManagers(stable_total_managers : Nat) {
      managerComposite.setStableTotalManagers(stable_total_managers);
    };

    public func getStableActiveManagerCanisterId() : T.CanisterId {
      return managerComposite.getStableActiveManagerCanisterId();
    };

    public func setStableActiveManagerCanisterId(stable_active_manager_canister_id : T.CanisterId) {
      managerComposite.setStableActiveManagerCanisterId(stable_active_manager_canister_id);
    };

    public func getStableTeamValueLeaderboards() : [(T.SeasonId, T.TeamValueLeaderboard)] {
      return managerComposite.getStableTeamValueLeaderboards();
    };

    public func setStableTeamValueLeaderboards(stable_team_value_leaderboards : [(T.SeasonId, T.TeamValueLeaderboard)]) {
      return managerComposite.setStableTeamValueLeaderboards(stable_team_value_leaderboards);
    };

    public func getStableSeasonRewards() : [T.SeasonRewards] {
      return managerComposite.getStableSeasonRewards();
    };

    public func setStableSeasonRewards(stable_season_rewards : [T.SeasonRewards]) {
      return managerComposite.setStableSeasonRewards(stable_season_rewards);
    };

    public func getStableMonthlyRewards() : [T.MonthlyRewards] {
      return managerComposite.getStableMonthlyRewards();
    };

    public func setStableMonthlyRewards(stable_monthly_rewards : [T.MonthlyRewards]) {
      return managerComposite.setStableMonthlyRewards(stable_monthly_rewards);
    };

    public func getStableWeeklyRewards() : [T.WeeklyRewards] {
      return managerComposite.getStableWeeklyRewards();
    };

    public func setStableWeeklyRewards(stable_weekly_rewards : [T.WeeklyRewards]) {
      return managerComposite.setStableWeeklyRewards(stable_weekly_rewards);
    };

    public func getStableMostValuableTeamRewards() : [T.RewardsList] {
      return managerComposite.getStableMostValuableTeamRewards();
    };

    public func setStableMostValuableTeamRewards(stable_most_valuable_team_rewards : [T.RewardsList]) {
      return managerComposite.setStableMostValuableTeamRewards(stable_most_valuable_team_rewards);
    };

    public func getStableHighestScoringPlayerRewards() : [T.RewardsList] {
      return managerComposite.getStableHighestScoringPlayerRewards();
    };

    public func setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards : [T.RewardsList]) {
      return managerComposite.setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards);
    };

    public func getStableWeeklyATHScores() : [T.HighScoreRecord] {
      return managerComposite.getStableWeeklyATHScores();
    };

    public func setStableWeeklyATHScores(stable_weekly_ath_scores : [T.HighScoreRecord]) {
      return managerComposite.setStableWeeklyATHScores(stable_weekly_ath_scores);
    };

    public func getStableMonthlyATHScores() : [T.HighScoreRecord] {
      return managerComposite.getStableMonthlyATHScores();
    };

    public func setStableMonthlyATHScores(stable_monthly_ath_scores : [T.HighScoreRecord]) {
      return managerComposite.setStableMonthlyATHScores(stable_monthly_ath_scores);
    };

    public func getStableSeasonATHScores() : [T.HighScoreRecord] {
      return managerComposite.getStableSeasonATHScores();
    };

    public func setStableSeasonATHScores(stable_season_ath_scores : [T.HighScoreRecord]) {
      return managerComposite.setStableSeasonATHScores(stable_season_ath_scores);
    };

    public func getStableWeeklyATHPrizePool() : Nat64 {
      return managerComposite.getStableWeeklyATHPrizePool();
    };

    public func setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool : Nat64) {
      return managerComposite.setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool);
    };

    public func getStableMonthlyATHPrizePool() : Nat64 {
      return managerComposite.getStableMonthlyATHPrizePool();
    };

    public func setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool : Nat64) {
      return managerComposite.setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool);
    };

    public func getStableSeasonATHPrizePool() : Nat64 {
      return managerComposite.getStableSeasonATHPrizePool();
    };

    public func setStableSeasonATHPrizePool(stable_season_ath_prize_pool : Nat64) {
      return managerComposite.setStableSeasonATHPrizePool(stable_season_ath_prize_pool);
    };

    public func getStableSeasonLeaderboardCanisters() : [T.SeasonLeaderboardCanister] {
      return leaderboardComposite.getStableSeasonLeaderboardCanisters();
    };

    public func setStableSeasonLeaderboardCanisters(stable_season_leaderboard_canisters : [T.SeasonLeaderboardCanister]) {
      leaderboardComposite.setStableSeasonLeaderboardCanisters(stable_season_leaderboard_canisters);
    };

    public func getStableMonthlyLeaderboardCanisters() : [T.MonthlyLeaderboardCanister] {
      return leaderboardComposite.getStableMonthlyLeaderboardCanisters();
    };

    public func setStableMonthlyLeaderboardCanisters(stable_monthly_leaderboard_canisters : [T.MonthlyLeaderboardCanister]) {
      leaderboardComposite.setStableMonthlyLeaderboardCanisters(stable_monthly_leaderboard_canisters);
    };

    public func getStableWeeklyLeaderboardCanisters() : [T.WeeklyLeaderboardCanister] {
      return leaderboardComposite.getStableWeeklyLeaderboardCanisters();
    };

    public func setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister]) {
      leaderboardComposite.setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters);
    };

    public func getStableClubs() : [T.Club] {
      return clubComposite.getStableClubs();
    };

    public func setStableClubs(stable_clubs : [T.Club]) {
      clubComposite.setStableClubs(stable_clubs);
    };

    public func getStableRelegatedClubs() : [T.Club] {
      return clubComposite.getStableRelegatedClubs();
    };

    public func setStableRelegatedClubs(stable_relegated_clubs : [T.Club]) {
      clubComposite.setStableRelegatedClubs(stable_relegated_clubs);
    };

    public func getStableNextClubId() : T.ClubId {
      return clubComposite.getStableNextClubId();
    };

    public func setStableNextClubId(stable_next_club_id : T.ClubId) {
      clubComposite.setStableNextClubId(stable_next_club_id);
    };

    public func getStablePlayers() : [T.Player] {
      return playerComposite.getStablePlayers();
    };

    public func setStablePlayers(stable_players : [T.Player]) {
      playerComposite.setStablePlayers(stable_players);
    };

    public func getStableNextPlayerId() : T.PlayerId {
      return playerComposite.getStableNextPlayerId();
    };

    public func setStableNextPlayerId(stable_next_player_id : T.PlayerId) {
      playerComposite.setStableNextPlayerId(stable_next_player_id);
    };

    public func getStableSeasons() : [T.Season] {
      return seasonComposite.getStableSeasons();
    };

    public func setStableSeasons(stable_seasons : [T.Season]) {
      seasonComposite.setStableSeasons(stable_seasons);
    };

    public func getStableNextSeasonId() : T.SeasonId {
      return seasonComposite.getStableNextSeasonId();
    };

    public func setStableNextSeasonId(stable_next_season_id : T.SeasonId) {
      seasonComposite.setStableNextSeasonId(stable_next_season_id);
    };

    public func getStableNextFixtureId() : T.FixtureId {
      return seasonComposite.getStableNextFixtureId();
    };

    public func setStableNextFixtureId(stable_next_fixture_id : T.FixtureId) {
      seasonComposite.setStableNextFixtureId(stable_next_fixture_id);
    };

    public func getStableDataHashes() : [T.DataCache] {
      return List.toArray(dataCacheHashes);
    };

    public func setStableDataHashes(stable_data_cache_hashes : [T.DataCache]) {
      dataCacheHashes := List.fromArray(stable_data_cache_hashes);
    };

    public func getStablePrivateLeagueCanisterIds() : [T.CanisterId] {
      return privateLeaguesManager.getStablePrivateLeagueCanisterIds();
    };

    public func setStablePrivateLeagueCanisterIds(stable_private_league_canister_ids: [T.CanisterId]) {
      privateLeaguesManager.setStablePrivateLeagueCanisterIds(stable_private_league_canister_ids);
    };

    public func getStablePrivateLeagueNameIndex() : [(T.CanisterId, Text)] {
      return privateLeaguesManager.getStablePrivateLeagueNameIndex();
    };

    public func setStablePrivateLeagueNameIndex(stable_private_league_name_index: [(T.CanisterId, Text)]) {
      privateLeaguesManager.setStablePrivateLeagueNameIndex(stable_private_league_name_index);
    };

    public func getStableUnacceptedInvites() : [(T.CanisterId, T.LeagueInvite)] {
      return privateLeaguesManager.getStableUnacceptedInvites();
    };

    public func setStablePrivateLeagueUnacceptedInvites(stable_private_league_unaccepted_invites: [(T.CanisterId, T.LeagueInvite)]) {
      privateLeaguesManager.setStableUnacceptedInvites(stable_private_league_unaccepted_invites);
    };

    public func getTotalCanisters() : Nat{
      return managerComposite.getTotalCanisters();
    };

    public func setInitialSeason(){
      seasonComposite.setInitialSeason();
    };

    public func setInitialClubs(){
      clubComposite.setInitialClubs();
    };

    public func setInitialPlayers(){
      playerComposite.setInitialPlayers();
    };

    public func getManagerCanisterIds() : [T.CanisterId] {
      return managerComposite.getStableUniqueManagerCanisterIds();
    };

    public func getActiveManagerCanisterId(): T.CanisterId {
      return managerComposite.getStableActiveManagerCanisterId();
    };  

    public func getRewardPool(seasonId: T.SeasonId) : ?T.RewardPool {
      return rewardPools.get(seasonId);
    };

    public func removeDuplicatePlayer(playerId: T.PlayerId) : async () {
      let clubs = Array.map<T.Club, T.ClubId>(clubComposite.getClubs(), func(club: T.Club){
        return club.id;
      });
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
      await managerComposite.removePlayerFromTeams(playerId, players);
      await playerComposite.removeDuplicatePlayer(playerId);
      await updateCacheHash("players");
    };

    public func updateRewardPool() : async () {

      let rewardPool : T.RewardPool = {
        seasonId = 1;
        seasonLeaderboardPool = 28125000000000;
        monthlyLeaderboardPool = 65625000000000;
        weeklyLeaderboardPool = 28125000000000;
        mostValuableTeamPool = 18750000000000;
        highestScoringMatchPlayerPool = 18750000000000;
        allTimeWeeklyHighScorePool = 9375000000000;
        allTimeMonthlyHighScorePool = 9375000000000;
        allTimeSeasonHighScorePool = 9375000000000;
      };

      rewardPools.put(1, rewardPool);
    };

    public func resetManagerBonusesAvailable() : async () {
      await managerComposite.resetBonusesAvailable();
    };

    public func putOnHold() : async (){
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        transferWindowActive = systemState.transferWindowActive;
        seasonActive = systemState.seasonActive;
        onHold = true;
      };

      systemState := updatedSystemState;
      await updateCacheHash("system_state");
    };

    public func snapshotFantasyTeams() : async (){
      await managerComposite.snapshotFantasyTeams(1,1,8);
    };

    public func getUniqueManagerCanisterIds() : [T.CanisterId] {
      managerComposite.getUniqueManagerCanisterIds();
    };

     public func getPlayerPointsMap(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async [(T.PlayerId, DTOs.PlayerScoreDTO)] {
      return playerComposite.getPlayersMap({ seasonId = seasonId; gameweek = gameweek });
    };

  };
};
