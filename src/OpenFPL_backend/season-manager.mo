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
import Debug "mo:base/Debug";

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

    //TODO: Check we need and check all has stable variable backup in OpenFPL main backend
    private var setAndBackupTimer : ?((duration : Timer.Duration, callbackName : Text) -> async ()) = null;
    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;
    private var recordSystemEvent : ?((eventLog: T.EventLogEntry) -> ()) = null;

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

    public func setTimerBackupFunction(
      _setAndBackupTimer : (duration : Timer.Duration, callbackName : Text) -> async (),
      _removeExpiredTimers : () -> (),
    ) {
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
      calculationGameweek = 6;
      calculationMonth = 9;
      calculationSeasonId = 1;
      pickTeamGameweek = 6;
      pickTeamSeasonId = 1;
      seasonActive = true;
      transferWindowActive = false;
      onHold = false;
      version = "V1.0.0";
    };

    public func getSystemState() : T.SystemState {
      return systemState;
    };

    public func getSystemStateDTO() : async Result.Result<DTOs.SystemStateDTO, T.Error> {
      let pickTeamSeasonResponse = await seasonComposite.getSeason(systemState.pickTeamSeasonId);
      let calculationSeasonResult = await seasonComposite.getSeason(systemState.calculationSeasonId);
      var pickTeamSeasonName = "";
      var calculationSeasonName = "";
      switch (pickTeamSeasonResponse) {
        case (#ok foundSeason) {
          pickTeamSeasonName := foundSeason.name;
          switch (calculationSeasonResult) {
            case (#ok foundSeason) {
              calculationSeasonName := foundSeason.name;
              return #ok({
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
                version = systemState.version;
              });
            };
            case (_) {
              return #err(#NotFound);
            };
          };
        };
        case (_){
          return #err(#NotFound);
        };
      };
    };

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

    public func setVersion(version : Text) : async () {
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
        version = version;
      };

      systemState := updatedSystemState;
      await updateCacheHash("system_state");
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

    public func getFixtures(dto: DTOs.GetFixturesDTO) : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return await seasonComposite.getFixtures(dto);
    };

    public func getSeasons() : async Result.Result<[DTOs.SeasonDTO], T.Error> {
      return await seasonComposite.getSeasons();
    };

    public func getPostponedFixtures() : async Result.Result<[DTOs.FixtureDTO], T.Error> {
      return await seasonComposite.getPostponedFixtures(systemState.calculationSeasonId);
    };

    public func getPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      let activeClubs = await clubComposite.getClubs();
      switch(activeClubs){
        case (#ok clubs){
          let players = await playerComposite.getActivePlayers(systemState.pickTeamSeasonId, Array.map<T.Club, T.ClubId>(clubs, func(club: T.Club){ return club.id }));
          switch(players){
            case (#ok foundPlayers){
              return #ok(foundPlayers);
            };
            case _ {
              return #err(#NotFound);
            }
          };
        };
        case (_){
          return #err(#NotFound);
        }
      };     
    };

    public func getAllPlayers() : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await playerComposite.getAllPlayers(systemState.calculationSeasonId);
    };

    public func getLoanedPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await playerComposite.getLoanedPlayers(dto);
    };

    public func getRetiredPlayers(dto: DTOs.ClubFilterDTO) : async Result.Result<[DTOs.PlayerDTO], T.Error> {
      return await playerComposite.getRetiredPlayers(dto);
    };

    public func getClubs() : async Result.Result<[DTOs.ClubDTO], T.Error> {
      return await clubComposite.getClubs();
    };

    public func getPlayerDetailsForGameweek(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[DTOs.PlayerPointsDTO], T.Error> {
      return await playerComposite.getPlayerDetailsForGameweek(dto);
    };

    public func getPlayerDetails(dto: DTOs.GetPlayerDetailsDTO) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      return await playerComposite.getPlayerDetails(dto);
    };

    public func getPlayersMap(dto: DTOs.GameweekFiltersDTO) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      let result = await playerComposite.getPlayersMap(dto);
      return result;
    };

    public func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getWeeklyLeaderboard(dto);
    };

    public func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getMonthlyLeaderboard(dto);
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

    public func getFantasyTeamSnapshot(dto: DTOs.GetFantasyTeamSnapshotDTO) : async Result.Result<DTOs.FantasyTeamSnapshotDTO, T.Error>{
     return await managerComposite.getFantasyTeamSnapshot(dto);   
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
       Debug.print("Saving fantasy team");

       let clubsResponse = await clubComposite.getClubs();
       switch(clubsResponse){
        case (#ok foundClubs){
          let clubs = Array.map<T.Club, T.ClubId>(foundClubs, func(club: T.Club){
            return club.id;
          });
          let playersResponse = await playerComposite.getActivePlayers(systemState.calculationSeasonId, clubs);
          switch(playersResponse){
            case  (#ok players){
              return await managerComposite.saveFantasyTeam(principalId, updatedFantasyTeam, systemState, players);  
            };
            case _ {
              return #err(#NotFound);
            }
          };
        };
        case _ {
          return #err(#NotFound);
        }
       };
    };

    public func updateUsername(principalId : Text, updatedUsername : Text) : async Result.Result<(), T.Error> {
      return await managerComposite.updateUsername(principalId, updatedUsername, systemState);
    };

    public func updateFavouriteClub(principalId : Text, clubId : T.ClubId) : async Result.Result<(), T.Error> {
      
      let clubsResponse = await clubComposite.getClubs();
       switch(clubsResponse){
        case (#ok clubs){
          return await managerComposite.updateFavouriteClub(principalId, clubId, systemState, clubs);
        };
        case _ {
          return #err(#NotFound);
        }
       };
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
      await setGameweekTimers(pickTeamGameweek);

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        transferWindowActive = systemState.transferWindowActive;
        seasonActive = true;
        onHold = systemState.onHold;
        version = systemState.version;
      };

      systemState := updatedSystemState;
      logSystemStatus();
      
      await managerComposite.snapshotFantasyTeams(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth); //
      await updateCacheHash("system_state");
    };

    private func logSystemStatus(){
        switch(recordSystemEvent){
          case null{};
          case (?function){
            function({
              eventDetail = 
                "System Status Updated: Calculation Gameweek: " # Nat8.toText(systemState.calculationGameweek) 
                  # ", Calculation Month: " # Nat8.toText(systemState.calculationMonth) 
                  # ", Calculation Season Id: " # Nat16.toText(systemState.calculationSeasonId) 
                  # ", Pick Team Gameweek: " # Nat8.toText(systemState.pickTeamGameweek) 
                  # ", Pick Team Season Id: " # Nat16.toText(systemState.pickTeamSeasonId) 
                  # ", Transfer Window Active: " # Bool.toText(systemState.transferWindowActive) 
                  # ", Season Active: " # Bool.toText(systemState.seasonActive) 
                  # ", On Hold: " # Bool.toText(systemState.onHold) # "."; 
              eventId = 0;
              eventTime = Time.now();
              eventTitle = "Canister Topup";
              eventType = #SystemCheck;
            });
          }
      };

    };

    public func gameKickOffExpiredCallback() : async () {
      let _ = await seasonComposite.setFixturesToActive(systemState.calculationSeasonId);
      await updateCacheHash("fixtures");
    };

    public func gameCompletedExpiredCallback() : async () {
      let _ = await seasonComposite.setFixturesToCompleted(systemState.calculationSeasonId);

      let seasonFixturesResponse = await seasonComposite.getFixtures({seasonId = systemState.pickTeamSeasonId});
      switch(seasonFixturesResponse){
        case (#ok seasonFixtures){

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
            version = systemState.version;
            };
          };
          logSystemStatus();
          
          await updateCacheHash("fixtures");

        };
        case (_){}
      };
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
        version = systemState.version;
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
        version = systemState.version;
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
        version = systemState.version;
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
        version = systemState.version;
      };

      systemState := updatedSystemState;
      logSystemStatus();
    };

    private func incrementCalculationSeason() : async () {
      
      var seasonId = systemState.calculationSeasonId;
      
      var nextSeasonId = seasonId + 1;
      let _ = await seasonComposite.setNextSeasonId(nextSeasonId);

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = nextSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
        version = systemState.version;
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
      let fixturesResult = await seasonComposite.getFixtures({seasonId = systemState.calculationSeasonId});
      switch(fixturesResult){
        case (#ok fixtures){
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
        case (_){

        }
      };
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
    
    //Governance validation and execution functions

    public func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      
      return await seasonComposite.validateAddInitialFixtures(addInitialFixturesDTO);
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {

      let _ = await seasonComposite.executeAddInitialFixtures(addInitialFixturesDTO);

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
        version = systemState.version;
      };

      systemState := updatedSystemState;
      logSystemStatus();

      await setGameweekTimers(1);
      await updateCacheHash("fixtures");
      return #ok();
    };

    public func validateSubmitFixtureData(submitFixtureDataDTO : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await seasonComposite.validateSubmitFixtureData(submitFixtureDataDTO);
    };

    public func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
      
      let playersResult = await playerComposite.getAllPlayers(systemState.calculationSeasonId);

      switch(playersResult){
        case (#ok players){
          let populatedPlayerEvents = await seasonComposite.populatePlayerEventData(submitFixtureData, players);
          switch (populatedPlayerEvents) {
            case (null) {
              return #err(#NotFound);
            };
            case (?events) {
              let _ = await playerComposite.addEventsToPlayers(events, submitFixtureData.seasonId, submitFixtureData.gameweek);
              let _ = await seasonComposite.addEventsToFixture(events, submitFixtureData.seasonId, submitFixtureData.fixtureId); 
              let _ = await seasonComposite.setGameScore(submitFixtureData.seasonId, submitFixtureData.fixtureId);
              let _ = await seasonComposite.setFixtureToFinalised(systemState.calculationSeasonId, submitFixtureData.fixtureId);
              return #ok();
            };
          };
        };
        case _ {
            return #err(#NotFound);
        }
      };
    };

    public func validateMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await seasonComposite.validateMoveFixture(moveFixtureDTO, systemState);
    };

    public func executeMoveFixture(moveFixtureDTO : DTOs.MoveFixtureDTO) : async Result.Result<(), T.Error> {
      let _ = await seasonComposite.executeMoveFixture(moveFixtureDTO, systemState);
      await updateCacheHash("fixtures");
      return #ok();
    };

    public func validatePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await seasonComposite.validatePostponeFixture(postponeFixtureDTO, systemState);
    };

    public func executePostponeFixture(postponeFixtureDTO : DTOs.PostponeFixtureDTO) : async Result.Result<(), T.Error> {
      let _ = await seasonComposite.executePostponeFixture(postponeFixtureDTO, systemState);
      await updateCacheHash("fixtures");
      return #ok();
    };

    public func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await seasonComposite.validateRescheduleFixture(rescheduleFixtureDTO, systemState);
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      let _ = await seasonComposite.executeRescheduleFixture(rescheduleFixtureDTO, systemState);
      await updateCacheHash("fixtures");
      return #ok();
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await playerComposite.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.revaluePlayerUp(revaluePlayerUpDTO);
      await updateCacheHash("fixtures");
      return #ok();
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      let _ = await playerComposite.validateRevaluePlayerDown(revaluePlayerDownDTO);
      await updateCacheHash("fixtures");
      return #ok();
    };

    public func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.revaluePlayerDown(revaluePlayerDownDTO);
      await updateCacheHash("players");
      return #ok();
    };

    public func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      let _ = await playerComposite.validateLoanPlayer(loanPlayerDTO);
      await updateCacheHash("fixtures");
      return #ok();
    };

    public func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.loanPlayer(loanPlayerDTO);
      await updateCacheHash("players");
      return #ok();
    };

    public func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      let clubs = clubComposite.getClubs();
      return await playerComposite.validateTransferPlayer(transferPlayerDTO);
    };

    public func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.transferPlayer(transferPlayerDTO);
      await updateCacheHash("players");
      return #ok();
     };

    public func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await playerComposite.validateRecallPlayer(recallPlayerDTO);
    };

    public func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.recallPlayer(recallPlayerDTO);
      await updateCacheHash("players");
      return #ok();
     };

    public func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      let clubs = clubComposite.getClubs();
      return await playerComposite.validateCreatePlayer(createPlayerDTO);
    };

    public func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.createPlayer(createPlayerDTO);
      await updateCacheHash("players");
      return #ok();
   };

    public func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await playerComposite.validateUpdatePlayer(updatePlayerDTO);
    };

    public func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
     let _ = await playerComposite.updatePlayer(updatePlayerDTO);
      await updateCacheHash("players");
      return #ok();
     };

    public func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await playerComposite.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.setPlayerInjury(setPlayerInjuryDTO);
      await updateCacheHash("players");
      return #ok();
    };

    public func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await playerComposite.validateRetirePlayer(retirePlayerDTO);
    };

    public func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.retirePlayer(retirePlayerDTO);
      await updateCacheHash("players");
      return #ok();
    };

    public func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await playerComposite.validateUnretirePlayer(unretirePlayerDTO);
    };

    public func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      let _ = await playerComposite.unretirePlayer(unretirePlayerDTO);
      await updateCacheHash("players");
      return #ok();
    };

    public func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await clubComposite.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public func executePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      let _ = await clubComposite.promoteFormerClub(promoteFormerClubDTO);
      await updateCacheHash("clubs");
      return #ok();
    };

    public func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await clubComposite.validatePromoteNewClub(promoteNewClubDTO);
    };

    public func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      let _ = await clubComposite.promoteNewClub(promoteNewClubDTO);
      await updateCacheHash("clubs");
      return #ok();
    };

    public func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      if(systemState.onHold){
        return #err(#NotAllowed);
      };
      return await clubComposite.validateUpdateClub(updateClubDTO);
    };

    public func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      let _ = await clubComposite.updateClub(updateClubDTO);
      await updateCacheHash("clubs");
      return #ok();
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

    public func getStableMonthlyLeaderboardsCanisters() : [T.MonthlyLeaderboardsCanister] {
      return leaderboardComposite.getStableMonthlyLeaderboardsCanisters();
    };

    public func setStableMonthlyLeaderboardsCanisters(stable_monthly_leaderboard_canisters : [T.MonthlyLeaderboardsCanister]) {
      leaderboardComposite.setStableMonthlyLeaderboardsCanisters(stable_monthly_leaderboard_canisters);
    };

    public func getStableWeeklyLeaderboardCanisters() : [T.WeeklyLeaderboardCanister] {
      return leaderboardComposite.getStableWeeklyLeaderboardCanisters();
    };

    public func setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister]) {
      leaderboardComposite.setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters);
    };

    public func getStableDataHashes() : [T.DataCache] {
      return List.toArray(dataCacheHashes);
    };

    public func setStableDataHashes(stable_data_cache_hashes : [T.DataCache]) {
      dataCacheHashes := List.fromArray(stable_data_cache_hashes);
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

    public func getManagerCanisterIds() : [T.CanisterId] {
      return managerComposite.getStableUniqueManagerCanisterIds();
    };

    public func getActiveManagerCanisterId(): T.CanisterId {
      return managerComposite.getStableActiveManagerCanisterId();
    };  

    public func getRewardPool(seasonId: T.SeasonId) : ?T.RewardPool {
      return rewardPools.get(seasonId);
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
        version = systemState.version;
      };

      systemState := updatedSystemState;
      await updateCacheHash("system_state");
    };

    public func updateVersion(newVersion: Text) : async (){
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        transferWindowActive = systemState.transferWindowActive;
        seasonActive = systemState.seasonActive;
        onHold = systemState.onHold;
        version = newVersion;
      };

      systemState := updatedSystemState;
      await updateCacheHash("system_state");
    };

    public func removeOnHold() : async (){
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        transferWindowActive = systemState.transferWindowActive;
        seasonActive = systemState.seasonActive;
        onHold = false;
        version = systemState.version;
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

     public func getPlayerPointsMap(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<[(T.PlayerId, DTOs.PlayerScoreDTO)], T.Error> {
      return await playerComposite.getPlayersMap({ seasonId = seasonId; gameweek = gameweek });
    };

    public func getOrderedSnapshots() : async [T.FantasyTeamSnapshot]{
      await managerComposite.getOrderedSnapshots();
    };

    public func setFixtureToComplete(seasonId: T.SeasonId, fixtureId: T.FixtureId) : async Result.Result<(), T.Error>{
      await seasonComposite.setFixtureToComplete(seasonId, fixtureId);
    };

    public func setGameScore(seasonId: T.SeasonId, fixtureId: T.FixtureId) : async Result.Result<(), T.Error>{
      await seasonComposite.setGameScore(seasonId, fixtureId);
    };

    public func calculateLeaderboards() : async () {
      await leaderboardComposite.calculateLeaderboards(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth, managerComposite.getStableUniqueManagerCanisterIds());
    };

    public func initialiseData() : async Result.Result<(), T.Error>{
      seasonComposite.initialiseData();
    };
  };

};
