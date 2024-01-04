import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Timer "mo:base/Timer";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Float "mo:base/Float";
import Int64 "mo:base/Int64";
import SeasonComposite "patterns/season-composite";
import PlayerComposite "patterns/player-composite";
import ClubComposite "patterns/club-composite";
import ManagerComposite "patterns/manager-composite";
import LeaderboardComposite "patterns/leaderboard-composite";
import SHA224 "./lib/SHA224";
import Utilities "utilities";
import CanisterIds "CanisterIds";
import Token "token";

module {

  public class SeasonManager() {

    private var setAndBackupTimer : ?((duration : Timer.Duration, callbackName : Text) -> ()) = null;
    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;

    let managerComposite = ManagerComposite.ManagerComposite();
    let playerComposite = PlayerComposite.PlayerComposite();
    let clubComposite = ClubComposite.ClubComposite();
    let seasonComposite = SeasonComposite.SeasonComposite();
    let leaderboardComposite = LeaderboardComposite.LeaderboardComposite();

    public func setBackendCanisterController(controller : Principal) {
      managerComposite.setBackendCanisterController(controller);
      leaderboardComposite.setBackendCanisterController(controller);
    };

    var rewardPools : HashMap.HashMap<T.SeasonId, T.RewardPool> = HashMap.HashMap<T.SeasonId, T.RewardPool>(100, Utilities.eqNat16, Utilities.hashNat16);

    private var systemState : T.SystemState = {
      calculationGameweek = 1;
      calculationMonth = 8;
      calculationSeasonId = 1;
      pickTeamGameweek = 1;
      pickTeamSeasonId = 1;
      transferWindowActive = false;
      onHold = false;
    };

    private var dataCacheHashes : List.List<T.DataCache> = List.fromArray([
      { category = "clubs"; hash = "DEFAULT_VALUE" },
      { category = "fixtures"; hash = "DEFAULT_VALUE" },
      { category = "weekly_leaderboard"; hash = "DEFAULT_VALUE" },
      { category = "monthly_leaderboards"; hash = "DEFAULT_VALUE" },
      { category = "season_leaderboard"; hash = "DEFAULT_VALUE" },
      { category = "players"; hash = "DEFAULT_VALUE" },
      { category = "player_events"; hash = "DEFAULT_VALUE" },
      { category = "countries"; hash = "DEFAULT_VALUE" },
    ]);

    public func setTimerBackupFunction(
      _setAndBackupTimer : (duration : Timer.Duration, callbackName : Text) -> (),
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

    private func updateCacheHash(category : Text) : async () {
      let hashBuffer = Buffer.fromArray<T.DataCache>([]);

      for (hashObj in Iter.fromList(dataCacheHashes)) {
        if (hashObj.category == category) {
          let randomHash = await SHA224.getRandomHash();
          hashBuffer.add({ category = hashObj.category; hash = randomHash });
        } else { hashBuffer.add(hashObj) };
      };

      dataCacheHashes := List.fromArray(Buffer.toArray<T.DataCache>(hashBuffer));
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
      };
    };

    public func getDataHashes() : [DTOs.DataCacheDTO] {
      return List.toArray(dataCacheHashes);
    };

    public func getFixtures(seasonId : T.SeasonId) : [DTOs.FixtureDTO] {
      return seasonComposite.getFixtures(seasonId);
    };

    public func getPlayers() : [DTOs.PlayerDTO] {
      return playerComposite.getActivePlayers(systemState.calculationSeasonId);
    };

    public func getLoanedPlayers(clubId: T.ClubId) : [DTOs.PlayerDTO] {
      return playerComposite.getLoanedPlayers(clubId);
    };

    public func getRetiredPlayers(clubId: T.ClubId) : [DTOs.PlayerDTO] {
      return playerComposite.getRetiredPlayers(clubId);
    };

    public func getClubs() : [DTOs.ClubDTO] {
      return clubComposite.getClubs();
    };

    public func getFormerClubs() : [DTOs.ClubDTO] {
      return clubComposite.getFormerClubs();
    };

    public func getPlayerDetailsForGameweek(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : [DTOs.PlayerPointsDTO] {
      return playerComposite.getPlayerDetailsForGameweek(seasonId, gameweek);
    };

    public func getPlayerDetails(playerId : T.PlayerId, seasonId : T.SeasonId) : async Result.Result<DTOs.PlayerDetailDTO, T.Error> {
      return await playerComposite.getPlayerDetails(playerId, seasonId);
    };

    public func getPlayersMap(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<[(Nat16, DTOs.PlayerScoreDTO)], T.Error> {
      let result = await playerComposite.getPlayersMap(seasonId, gameweek);
      return #ok(result);
    };

    public func getWeeklyLeaderboard(seasonId : T.SeasonId, gameweek : T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getWeeklyLeaderboard(seasonId, gameweek, limit, offset);
    };

    public func getMonthlyLeaderboard(seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getMonthlyLeaderboard(seasonId, month, clubId, limit, offset);
    };

    public func getMonthlyLeaderboards(seasonId : T.SeasonId, month : T.CalendarMonth) : async Result.Result<[DTOs.MonthlyLeaderboardDTO], T.Error> {
      let clubs = clubComposite.getClubs();
      return await leaderboardComposite.getMonthlyLeaderboards(seasonId, month, clubs);
    };

    public func getSeasonLeaderboard(seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      return await leaderboardComposite.getSeasonLeaderboard(seasonId, limit, offset);
    };

    public func getProfile(principalId : Text) : async Result.Result<DTOs.ProfileDTO, T.Error> {
      return await managerComposite.getProfile(principalId);
    };

    public func getPublicProfile(principalId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<DTOs.PublicProfileDTO, T.Error> {
      return await managerComposite.getPublicProfile(principalId, seasonId, gameweek);
    };

    public func getManager(principalId : Text) : async Result.Result<DTOs.ManagerDTO, T.Error> {

      let weeklyLeaderboardEntry = await leaderboardComposite.getWeeklyLeaderboardEntry(principalId, systemState.calculationSeasonId, systemState.calculationGameweek);

      let managerFavouriteClub = managerComposite.getFavouriteClub(principalId);

      var monthlyLeaderboardEntry : ?DTOs.LeaderboardEntryDTO = null;
      if (managerFavouriteClub > 0) {
        monthlyLeaderboardEntry := await leaderboardComposite.getMonthlyLeaderboardEntry(principalId, systemState.calculationSeasonId, systemState.calculationMonth, managerFavouriteClub);
      };

      let seasonLeaderboardEntry = await leaderboardComposite.getSeasonLeaderboardEntry(principalId, systemState.calculationSeasonId);

      return await managerComposite.getManager(principalId, systemState.calculationSeasonId, weeklyLeaderboardEntry, monthlyLeaderboardEntry, seasonLeaderboardEntry);
    };

    public func getManagerGameweek(principalId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Result.Result<DTOs.ManagerGameweekDTO, T.Error> {
      return await managerComposite.getManagerGameweek(principalId, seasonId, gameweek);
    };

    public func getTotalManagers() : Nat {
      return managerComposite.getTotalManagers();
    };

    public func saveFantasyTeam(principalId : Text, updatedFantasyTeam : DTOs.UpdateFantasyTeamDTO) : async Result.Result<(), T.Error> {
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
      return await managerComposite.saveFantasyTeam(principalId, updatedFantasyTeam, systemState, players);
    };

    public func updateUsername(principalId : Text, updatedUsername : Text) : async Result.Result<(), T.Error> {
      return await managerComposite.updateUsername(principalId, updatedUsername);
    };

    public func isUsernameValid(username : Text, principalId : Text) : Bool {
      return managerComposite.isUsernameValid(username, principalId);
    };

    public func updateFavouriteClub(principalId : Text, clubId : T.ClubId) : async Result.Result<(), T.Error> {
      return await managerComposite.updateFavouriteClub(principalId, clubId, systemState);
    };

    public func updateProfilePicture(principalId : Text, profilePicture : Blob) : async Result.Result<(), T.Error> {
      return await managerComposite.updateProfilePicture(principalId, profilePicture);
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
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;

      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
      managerComposite.snapshotFantasyTeams(systemState.calculationSeasonId, systemState.calculationGameweek, players);
      await updateCacheHash("system_state");
    };

    public func gameKickOffExpiredCallback() : async () {
      seasonComposite.setFixturesToActive(systemState.calculationSeasonId, systemState.calculationGameweek);
      await updateCacheHash("fixtures");
    };

    public func gameCompletedExpiredCallback() : async () {
      seasonComposite.setFixturesToCompleted(systemState.calculationSeasonId, systemState.calculationGameweek);
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
        transferWindowActive = true;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      await updateCacheHash("system_state");
    };

    public func transferWindowEndCallback() : async () {
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        transferWindowActive = false;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
      await updateCacheHash("system_state");
    };

    //Governance validation and execution functions
    public func validateSubmitFixtureData(submitFixtureDataDTO : DTOs.SubmitFixtureDataDTO) : async Result.Result<Text, Text> {
      return await seasonComposite.validateSubmitFixtureData(submitFixtureDataDTO);
    };

    public func executeSubmitFixtureData(submitFixtureData : DTOs.SubmitFixtureDataDTO) : async () {
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
      let populatedPlayerEvents = await seasonComposite.populatePlayerEventData(submitFixtureData, players);
      switch (populatedPlayerEvents) {
        case (null) {};
        case (?events) {
          await playerComposite.addEventsToPlayers(events, submitFixtureData.seasonId, submitFixtureData.gameweek);
          await seasonComposite.addEventsToFixture(events, submitFixtureData.seasonId, submitFixtureData.fixtureId);
        };
      };

      let playerPointsMap = await playerComposite.getPlayersMap(systemState.calculationSeasonId, systemState.calculationGameweek);

      await managerComposite.calculateFantasyTeamScores(playerPointsMap, systemState.calculationSeasonId, systemState.calculationGameweek);

      let managers = managerComposite.getManagers();
      await leaderboardComposite.calculateLeaderboards(systemState.calculationSeasonId, systemState.calculationGameweek, systemState.calculationMonth, managers);

      await payRewards();
      await incrementSystemState();

      await updateCacheHash("players");
      await updateCacheHash("player_events");
      await updateCacheHash("fixtures");
      await updateCacheHash("weekly_leaderboard");
      await updateCacheHash("monthly_leaderboards");
      await updateCacheHash("season_leaderboard");
      await updateCacheHash("system_state");
    };

    private func incrementSystemState() : async () {

      var currentGameweek = systemState.calculationGameweek;
      var currentMonth = systemState.calculationMonth;
      var currentSeasonId = systemState.calculationSeasonId;

      let gameweekComplete = seasonComposite.checkGameweekComplete(systemState);
      if (gameweekComplete) {
        managerComposite.resetTransfers();
        let seasonComplete = seasonComposite.checkSeasonComplete(systemState);
        if (seasonComplete) {

          seasonComposite.createNewSeason(systemState);
          currentSeasonId := seasonComposite.getStableNextSeasonId();
          currentMonth := 8;
          currentGameweek := 1;
          setTransferWindowTimers();
          managerComposite.resetFantasyTeams();
          await calculateRewardPool(currentSeasonId);
        };

        let monthComplete = seasonComposite.checkMonthComplete(systemState);
        if (monthComplete) {
          managerComposite.resetBonusesAvailable();
          if (currentMonth == 12) {
            currentMonth := 1;
          } else {
            currentMonth := currentMonth + 1;
          };
        };
        currentGameweek := currentGameweek + 1;
      };

      let updatedSystemState : T.SystemState = {
        calculationGameweek = currentGameweek;
        calculationMonth = currentMonth;
        calculationSeasonId = currentSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = 1;
        transferWindowActive = true;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;
    };

    private func setTransferWindowTimers() {
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {

          let jan1Date = Utilities.nextUnixTimeForDayOfYear(1);
          let jan31Date = Utilities.nextUnixTimeForDayOfYear(31);

          let transferWindowStartDate : Timer.Duration = #nanoseconds(Int.abs(jan1Date - Time.now()));
          let transferWindowEndDate : Timer.Duration = #nanoseconds(Int.abs(jan31Date - Time.now()));

          actualFunction(transferWindowStartDate, "transferWindowStart");
          actualFunction(transferWindowEndDate, "transferWindowEnd");
        };
      };
    };

    private func payRewards() : async () {
      let rewardPool = rewardPools.get(systemState.calculationSeasonId);
      switch (rewardPool) {
        case (null) {};
        case (?foundRewardPool) {
          var calculationGameweek = systemState.calculationGameweek;
          var calculationMonth = systemState.calculationMonth;
          var calculationSeasonId = systemState.calculationSeasonId;

          let gameweekComplete = seasonComposite.checkGameweekComplete(systemState);
          if (gameweekComplete) {
            await payWeeklyRewards(foundRewardPool);
          };

          let monthComplete = seasonComposite.checkMonthComplete(systemState);
          if (monthComplete) {
            pauseFavouriteClubUpdates();
            let clubs = clubComposite.getClubs();
            for (club in Iter.fromArray(clubs)) {
              await payMonthlyRewards(foundRewardPool, club.id);
            };
            await payATHMonthlyRewards(foundRewardPool, clubs);
            resumeFavouriteClubUpdates();
          };

          let seasonComplete = seasonComposite.checkSeasonComplete(systemState);
          if (seasonComplete) {
            await paySeasonRewards(foundRewardPool);
          };
        };
      };

    };

    private func pauseFavouriteClubUpdates() {

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        transferWindowActive = systemState.transferWindowActive;
        onHold = true;
      };

      systemState := updatedSystemState;
    };

    private func resumeFavouriteClubUpdates() {

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        transferWindowActive = systemState.transferWindowActive;
        onHold = false;
      };

      systemState := updatedSystemState;
    };

    private func payWeeklyRewards(rewardPool : T.RewardPool) : async () {
      let weeklyLeaderboardCanisterId = await leaderboardComposite.getWeeklyCanisterId(systemState.calculationSeasonId, systemState.calculationGameweek);
      switch (weeklyLeaderboardCanisterId) {
        case (null) {};
        case (?canisterId) {
          let weekly_leaderboard_canister = actor (canisterId) : actor {
            getRewardLeaderboard : () -> async DTOs.WeeklyLeaderboardDTO;
          };

          let weeklyLeaderboard = await weekly_leaderboard_canister.getRewardLeaderboard();
          let fixtures = seasonComposite.getFixtures(systemState.calculationSeasonId);
          let gameweekFixtures = Array.filter<DTOs.FixtureDTO>(
            fixtures,
            func(fixture : DTOs.FixtureDTO) : Bool {
              return fixture.gameweek == weeklyLeaderboard.gameweek;
            },
          );
          await managerComposite.payWeeklyRewards(rewardPool, weeklyLeaderboard, List.fromArray(gameweekFixtures));
        };
      };
    };

    private func payMonthlyRewards(rewardPool : T.RewardPool, clubId : T.ClubId) : async () {
      let monthlyLeaderboardCanisterId = await leaderboardComposite.getMonthlyCanisterId(systemState.calculationSeasonId, systemState.calculationMonth, clubId);
      switch (monthlyLeaderboardCanisterId) {
        case (null) {};
        case (?canisterId) {
          let monthly_leaderboard_canister = actor (canisterId) : actor {
            getRewardLeaderboard : () -> async DTOs.MonthlyLeaderboardDTO;
          };

          let monthlyLeaderboard = await monthly_leaderboard_canister.getRewardLeaderboard();
          await managerComposite.payMonthlyRewards(rewardPool, monthlyLeaderboard);
        };
      };
    };

    private func payATHMonthlyRewards(rewardPool : T.RewardPool, clubs : [T.Club]) : async () {
      let allMonthlyLeaderboards = Buffer.fromArray<DTOs.MonthlyLeaderboardDTO>([]);

      for (club in Iter.fromArray(clubs)) {
        let monthlyLeaderboardCanisterId = await leaderboardComposite.getMonthlyCanisterId(systemState.calculationSeasonId, systemState.calculationMonth, club.id);
        switch (monthlyLeaderboardCanisterId) {
          case (null) {};
          case (?canisterId) {
            let monthly_leaderboard_canister = actor (canisterId) : actor {
              getRewardLeaderboard : () -> async DTOs.MonthlyLeaderboardDTO;
            };

            let monthlyLeaderboard = await monthly_leaderboard_canister.getRewardLeaderboard();
            allMonthlyLeaderboards.add(monthlyLeaderboard);
          };
        };

        await managerComposite.payATHMonthlyRewards(rewardPool, Buffer.toArray(allMonthlyLeaderboards));
      };
    };

    private func paySeasonRewards(rewardPool : T.RewardPool) : async () {
      let seasonLeaderboardCanisterId = await leaderboardComposite.getSeasonCanisterId(systemState.calculationSeasonId);
      switch (seasonLeaderboardCanisterId) {
        case (null) {};
        case (?canisterId) {
          let season_leaderboard_canister = actor (canisterId) : actor {
            getRewardLeaderboard : () -> async DTOs.SeasonLeaderboardDTO;
          };
          let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
          let seasonLeaderboard = await season_leaderboard_canister.getRewardLeaderboard();
          await managerComposite.paySeasonRewards(rewardPool, seasonLeaderboard, players, systemState.calculationSeasonId);
        };
      };
    };

    public func validateAddInitialFixtures(addInitialFixturesDTO : DTOs.AddInitialFixturesDTO) : async Result.Result<Text, Text> {
      let clubs = clubComposite.getClubs();
      return await seasonComposite.validateAddInitialFixtures(addInitialFixturesDTO, clubs);
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
        transferWindowActive = true;
        onHold = systemState.onHold;
      };

      systemState := updatedSystemState;

      await setGameweekTimers();
      await updateCacheHash("fixtures");
    };

    private func setGameweekTimers() : async () {
      let fixtures = seasonComposite.getFixtures(systemState.calculationSeasonId);
      let filteredFilters = Array.filter<DTOs.FixtureDTO>(
        fixtures,
        func(fixture : DTOs.FixtureDTO) : Bool {
          return fixture.gameweek == systemState.pickTeamGameweek;
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
          actualFunction(durationToHourBeforeFirstFixture, "gameweekBeginExpired");
        };
      };

      setKickOffTimers(fixtures);
    };

    private func setKickOffTimers(gameweekFixtures : [DTOs.FixtureDTO]) {
      for (fixture in Iter.fromArray(gameweekFixtures)) {
        switch (setAndBackupTimer) {
          case (null) {};
          case (?actualFunction) {
            let durationToKickOff : Timer.Duration = #nanoseconds(Int.abs(fixture.kickOff - Time.now()));
            let durationToGameOver : Timer.Duration = #nanoseconds(Int.abs(fixture.kickOff + (Utilities.getHour() * 2) - Time.now()));
            actualFunction(durationToKickOff, "gameKickOffExpired");
            actualFunction(durationToKickOff, "gameCompletedExpired");
          };
        };
      };
    };

    private func calculateRewardPool(seasonId : T.SeasonId) : async () {

      let tokenCanisterInstance = Token.Token();
      let totalSupply : Nat64 = await tokenCanisterInstance.getTotalSupply();

      let seasonTokensMinted = Utilities.nat64Percentage(Utilities.nat64Percentage(totalSupply, 0.025), 0.75);

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

    public func validateRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async Result.Result<Text, Text> {
      return await seasonComposite.validateRescheduleFixture(rescheduleFixtureDTO, systemState);
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO : DTOs.RescheduleFixtureDTO) : async () {
      return await seasonComposite.executeRescheduleFixture(rescheduleFixtureDTO);
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async Result.Result<Text, Text> {
      return await playerComposite.validateRevaluePlayerUp(revaluePlayerUpDTO);
    };

    public func executeRevaluePlayerUp(revaluePlayerUpDTO : DTOs.RevaluePlayerUpDTO) : async () {
      await playerComposite.executeRevaluePlayerUp(revaluePlayerUpDTO, systemState);
      await updateCacheHash("players");
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async Result.Result<Text, Text> {
      return await playerComposite.validateRevaluePlayerDown(revaluePlayerDownDTO);
    };

    public func executeRevaluePlayerDown(revaluePlayerDownDTO : DTOs.RevaluePlayerDownDTO) : async () {
      await playerComposite.executeRevaluePlayerDown(revaluePlayerDownDTO, systemState);
      await updateCacheHash("players");
    };

    public func validateLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async Result.Result<Text, Text> {
      let clubs = clubComposite.getClubs();
      return await playerComposite.validateLoanPlayer(loanPlayerDTO, List.fromArray(clubs));
    };

    public func executeLoanPlayer(loanPlayerDTO : DTOs.LoanPlayerDTO) : async () {
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
      await managerComposite.removePlayerFromTeams(loanPlayerDTO.playerId, players);
      await playerComposite.executeLoanPlayer(loanPlayerDTO, systemState);
      await updateCacheHash("players");
    };

    public func validateTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async Result.Result<Text, Text> {
      let clubs = clubComposite.getClubs();
      return await playerComposite.validateTransferPlayer(transferPlayerDTO, List.fromArray(clubs));
    };

    public func executeTransferPlayer(transferPlayerDTO : DTOs.TransferPlayerDTO) : async () {
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
      await managerComposite.removePlayerFromTeams(transferPlayerDTO.playerId, players);
      await playerComposite.executeTransferPlayer(transferPlayerDTO, systemState);
      await updateCacheHash("players");
    };

    public func validateRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async Result.Result<Text, Text> {
      return await playerComposite.validateRecallPlayer(recallPlayerDTO);
    };

    public func executeRecallPlayer(recallPlayerDTO : DTOs.RecallPlayerDTO) : async () {
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
      await managerComposite.removePlayerFromTeams(recallPlayerDTO.playerId, players);
      await playerComposite.executeRecallPlayer(recallPlayerDTO);
      await updateCacheHash("players");
    };

    public func validateCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async Result.Result<Text, Text> {
      let clubs = clubComposite.getClubs();
      return await playerComposite.validateCreatePlayer(createPlayerDTO, List.fromArray(clubs));
    };

    public func executeCreatePlayer(createPlayerDTO : DTOs.CreatePlayerDTO) : async () {
      await playerComposite.executeCreatePlayer(createPlayerDTO);
      await updateCacheHash("players");
    };

    public func validateUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async Result.Result<Text, Text> {
      return await playerComposite.validateUpdatePlayer(updatePlayerDTO);
    };

    public func executeUpdatePlayer(updatePlayerDTO : DTOs.UpdatePlayerDTO) : async () {
      let currentPlayerPosition = playerComposite.getPlayerPosition(updatePlayerDTO.playerId);
      await playerComposite.executeUpdatePlayer(updatePlayerDTO);
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
    
      
      switch(currentPlayerPosition){
        case (null) { return };
        case (?foundPosition){
          var removePlayer = false;
          if(foundPosition != updatePlayerDTO.position){
            await managerComposite.removePlayerFromTeams(updatePlayerDTO.playerId, players);
          };

          await updateCacheHash("players");
        }
      }
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async Result.Result<Text, Text> {
      return await playerComposite.validateSetPlayerInjury(setPlayerInjuryDTO);
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO : DTOs.SetPlayerInjuryDTO) : async () {
      await playerComposite.executeSetPlayerInjury(setPlayerInjuryDTO);
      await updateCacheHash("players");
    };

    public func validateRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async Result.Result<Text, Text> {
      return await playerComposite.validateRetirePlayer(retirePlayerDTO);
    };

    public func executeRetirePlayer(retirePlayerDTO : DTOs.RetirePlayerDTO) : async () {
      let players = playerComposite.getActivePlayers(systemState.calculationSeasonId);
      await managerComposite.removePlayerFromTeams(retirePlayerDTO.playerId, players);
      await playerComposite.executeRetirePlayer(retirePlayerDTO);
      await updateCacheHash("players");
    };

    public func validateUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async Result.Result<Text, Text> {
      return await playerComposite.validateUnretirePlayer(unretirePlayerDTO);
    };

    public func executeUnretirePlayer(unretirePlayerDTO : DTOs.UnretirePlayerDTO) : async () {
      return await playerComposite.executeUnretirePlayer(unretirePlayerDTO);
    };

    public func validatePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async Result.Result<Text, Text> {
      return await clubComposite.validatePromoteFormerClub(promoteFormerClubDTO);
    };

    public func executePromoteFormerClub(promoteFormerClubDTO : DTOs.PromoteFormerClubDTO) : async () {
      return await clubComposite.executePromoteFormerClub(promoteFormerClubDTO);
    };

    public func validatePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async Result.Result<Text, Text> {
      return await clubComposite.validatePromoteNewClub(promoteNewClubDTO);
    };

    public func executePromoteNewClub(promoteNewClubDTO : DTOs.PromoteNewClubDTO) : async () {
      return await clubComposite.executePromoteNewClub(promoteNewClubDTO);
    };

    public func validateUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async Result.Result<Text, Text> {
      return await clubComposite.validateUpdateClub(updateClubDTO);
    };

    public func executeUpdateClub(updateClubDTO : DTOs.UpdateClubDTO) : async () {
      return await clubComposite.executeUpdateClub(updateClubDTO);
    };

    //Stable data getters and setters:
    public func getStableRewardPools() : [(T.SeasonId, T.RewardPool)] {
      Iter.toArray(rewardPools.entries());
    };

    public func setStableRewardPools(stable_reward_pools : [(T.SeasonId, T.RewardPool)]) {
      rewardPools := HashMap.fromIter<T.SeasonId, T.RewardPool>(
        stable_reward_pools.vals(),
        stable_reward_pools.size(),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    };

    public func getStableManagers() : [(Text, T.Manager)] {
      return managerComposite.getStableManagers();
    };

    public func setStableManagers(stable_managers : [(Text, T.Manager)]) {
      managerComposite.setStableManagers(stable_managers);
    };

    public func getStableProfilePictureCanisterIds() : [(T.PrincipalId, Text)] {
      return managerComposite.getStableProfilePictureCanisterIds();
    };

    public func setStableProfilePictureCanisterIds(stable_profile_picture_canister_ids : [(T.PrincipalId, Text)]) {
      managerComposite.setStableProfilePictureCanisterIds(stable_profile_picture_canister_ids);
    };

    public func getStableActiveProfilePictureCanisterId() : Text {
      return managerComposite.getStableActiveProfilePictureCanisterId();
    };

    public func setStableActiveProfilePictureCanisterId(stable_active_profile_picture_canister_id : Text) {
      managerComposite.setStableActiveProfilePictureCanisterId(stable_active_profile_picture_canister_id);
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

    public func getSeasonATHPrizePool() : Nat64 {
      return managerComposite.getSeasonATHPrizePool();
    };

    public func setSeasonATHPrizePool(stable_season_ath_prize_pool : Nat64) {
      return managerComposite.setSeasonATHPrizePool(stable_season_ath_prize_pool);
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

    public func getStableSystemState() : T.SystemState {
      return systemState;
    };

    public func setStableSystemState(stable_system_state : T.SystemState) {
      systemState := stable_system_state;
    };

    /* Admin Functions to Remove  */

    public func updateSystemState(updatedSystemStateDTO : DTOs.UpdateSystemStateDTO) : async Result.Result<(), T.Error> {

      let pickTeamSeason = seasonComposite.getSeason(updatedSystemStateDTO.pickTeamSeasonId);

      systemState := {
        pickTeamSeasonId = updatedSystemStateDTO.pickTeamSeasonId;
        pickTeamGameweek = updatedSystemStateDTO.pickTeamGameweek;
        calculationGameweek = updatedSystemStateDTO.calculationGameweek;
        calculationMonth = updatedSystemStateDTO.calculationMonth;
        calculationSeasonId = updatedSystemStateDTO.calculationSeasonId;
        transferWindowActive = updatedSystemStateDTO.transferWindowActive;
        onHold = updatedSystemStateDTO.onHold;
      };
      return #ok;
    };

    public func updateFixture(updateFixtureDTO : DTOs.UpdateFixtureDTO) : async Result.Result<(), T.Error> {
      return await seasonComposite.updateFixture(updateFixtureDTO);
    };

    public func adminGetFixtures(seasonId : T.SeasonId) : DTOs.AdminFixtureList {

      let fixtures = getFixtures(seasonId);

      return {
        seasonId = seasonId;
        fixtures = fixtures;
      };
    };

    public func adminGetClubs(limit : Nat, offset : Nat) : DTOs.AdminClubList {
      let clubs = getClubs();
      let droppedEntries = List.drop<DTOs.ClubDTO>(List.fromArray(clubs), offset);
      let paginatedEntries = List.take<DTOs.ClubDTO>(droppedEntries, limit);

      return {
        clubs = List.toArray(paginatedEntries);
        limit = limit;
        offset = offset;
        totalEntries = Array.size(clubs);
      };
    };

    public func adminGetPlayers(status : T.PlayerStatus) : DTOs.AdminPlayerList {
      let players = getPlayers();

      let filteredPlayers = Array.filter<DTOs.PlayerDTO>(
        players,
        func(player : DTOs.PlayerDTO) : Bool {
          return player.status == status;
        },
      );

      return {
        players = filteredPlayers;
        playerStatus = status;
      };
    };

    public func adminGetManagers(limit : Nat, offset : Nat) : DTOs.AdminProfileList {
      return managerComposite.adminGetManagers(limit, offset);
    };

  };
};
