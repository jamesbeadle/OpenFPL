import T "types";
import DTOs "DTOs";
import Timer "mo:base/Timer";
import { now } = "mo:base/Time";
import Int "mo:base/Int";
import FantasyTeams "fantasy-teams";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import List "mo:base/List";
import Seasons "seasons";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Result "mo:base/Result";

module {

  public class SeasonManager() {

    let systemState: T.SystemState = {
      calculationGameweek = 1;
      calculationMonth = 8;
      calculationSeason = 1;
      pickTeamGameweek = 1;
      homepageFixturesGameweek = 1;
      homepageManagerGameweek = 0;
    };

    //Live canisters
    let CANISTER_IDS = {
      retired_players_canister = "pec6o-uqaaa-aaaal-qb7eq-cai";
      former_players_canister = "pec6o-uqaaa-aaaal-qb7eq-cai";
      token_canister = "hwd4h-eyaaa-aaaal-qb6ra-cai";
      governance_canister = "rrkah-fqaaa-aaaaa-aaaaq-cai";
    };

    let tokenCanister = actor (CANISTER_IDS.token_canister) : actor {
      icrc1_name : () -> async Text;
      icrc1_total_supply : () -> async Nat;
      icrc1_balance_of : (T.Account) -> async Nat;
    };

    let former_players_canister = actor (CANISTER_IDS.former_players_canister) : T.PlayerCanister;
    let retired_players_canister = actor (CANISTER_IDS.retired_players_canister) : T.PlayerCanister;

    private var dataCacheHashes : List.List<T.DataCache> = List.fromArray([
      { category = "clubs"; hash = "DEFAULT_VALUE" },
      { category = "fixtures"; hash = "DEFAULT_VALUE" },
      { category = "weekly_leaderboard"; hash = "DEFAULT_VALUE" },
      { category = "monthly_leaderboards"; hash = "DEFAULT_VALUE" },
      { category = "season_leaderboard"; hash = "DEFAULT_VALUE" },
      { category = "players"; hash = "DEFAULT_VALUE" },
      { category = "player_events"; hash = "DEFAULT_VALUE" }
    ]);

    private var managers: HashMap.HashMap<T.PrincipalId, T.Manager> = HashMap.HashMap<PrincipalId, T.Manager>(100, Text.equal, Text.hash);
    private var profilePictures : HashMap.HashMap<Text, Blob> = HashMap.HashMap<Text, Blob>(100, Text.equal, Text.hash);    
    private var players = List.fromArray<T.Player>([]);
    private var seasons = List.fromArray<T.Season>([]);

    private var nextPlayerId : Nat = 1;
    private var nextSeasonId : Nat16 = 1;
    private var nextFixtureId : Nat32 = 1;

    private var gameBegun = false;
    public func init() : Result.Result<(), T.Error> {
      
      if(gameBegun){
        return #err(#NotAllowed);
      }

      //Check for fixtures

      //if first fixture in past then fail

      return #ok();
    };

    public func getProfile(principalId: Text) : ProfileDTO{

    }
   //include all profile info for caller
    //include all manager info
    //GetProfile
      //GetGameweekPoints?? - Replace with GetProfile which includes their season history
      //Will include their current team and the pick team should copy from this for the in game session changes
    return #ok();










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





















    //child modules
    let profilesInstance = Profiles.Profiles();
    let teamsInstance = Teams.Teams();
    let rewardsInstance = Rewards.Rewards();
    let countriesInstance = Countries.Countries();
    private let seasonsInstance = Seasons.Seasons();

    //definitions
    private let oneHour = 1_000_000_000 * 60 * 60;

    private var setAndBackupTimer : ?((duration : Timer.Duration, callbackName : Text, fixtureId : T.FixtureId) -> async ()) = null;

    public func setData(stable_seasons : [T.Season], stable_active_season_id : Nat16, stable_active_gameweek : Nat8, stable_active_fixtures : [T.Fixture], stable_next_fixture_id : Nat32, stable_next_season_id : Nat16, stable_interesting_gameweek : Nat8) {
      activeSeasonId := stable_active_season_id;
      activeGameweek := stable_active_gameweek;
      interestingGameweek := stable_interesting_gameweek;
      seasonsInstance.setSeasons(stable_seasons);
      seasonsInstance.setNextFixtureId(stable_next_fixture_id);
      seasonsInstance.setNextSeasonId(stable_next_season_id);
    };

    public func seasonActive() : Bool {

      if (activeGameweek > 1) {
        return true;
      };

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
      if (List.some(List.fromArray(activeFixtures), func(fixture : T.Fixture) : Bool { return fixture.status > 0 })) {
        return true;
      };

      return false;
    };

    public func getNextFixtureId() : Nat32 {
      return seasonsInstance.getNextFixtureId();
    };

    public func getNextSeasonId() : Nat16 {
      return seasonsInstance.getNextSeasonId();
    };

    public func gameweekBegin() : async () {

      await snapshotGameweek(activeSeasonId, activeGameweek);

      await resetTransfers();

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
      var gameKickOffTimers = List.nil<T.TimerInfo>();
      for (i in Iter.range(0, Array.size(activeFixtures) - 1)) {
        let gameKickOffDuration : Timer.Duration = #nanoseconds(Int.abs(activeFixtures[i].kickOff - Time.now()));
        switch (setAndBackupTimer) {
          case (null) {};
          case (?actualFunction) {
            await actualFunction(gameKickOffDuration, "gameKickOffExpired", activeFixtures[i].id);
          };
        };
      };
    };

    public func gameKickOff() : async () {

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
      for (i in Iter.range(0, Array.size(activeFixtures) -1)) {
        if (activeFixtures[i].kickOff <= Time.now() and activeFixtures[i].status == 0) {

          let updatedFixture = await seasonsInstance.updateStatus(activeSeasonId, activeGameweek, activeFixtures[i].id, 1);
          let gameCompletedDuration : Timer.Duration = #nanoseconds(Int.abs((Time.now() + (oneHour * 2)) - Time.now()));
          switch (setAndBackupTimer) {
            case (null) {};
            case (?actualFunction) {
              await actualFunction(gameCompletedDuration, "gameCompletedExpired", activeFixtures[i].id);
            };
          };
        };
      };
      await updateCacheHash("fixtures");
    };

    public func gameCompleted() : async () {


    //NEED TO CHECK IF JANUARY 1ST IS IN THE UPCOMING GAMEWEEK THEN SET A TIMER TO BEGIN THE TRANSFER WINDOW IF IT IS
    //NEED TO CHECK IF JANUARY 31ST IS IN THE UPCOMING GAMEWEEK THEN SET A TIMER TO END THE TRANSFER WINDOW IF IT IS



      let EventData_VotingPeriod = 0; // NEED TO SET THIS FROM THE GOVERNANCE CANISTER BUT IT NEEDS TO BE THE TIME SPECIFIC TO FIXTURE DATA COLLECTION

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
      let timerCreatedTimes = Buffer.fromArray<Int>([]);

      for (i in Iter.range(0, Array.size(activeFixtures) -1)) {
        if ((activeFixtures[i].kickOff + (oneHour * 2)) <= Time.now() and activeFixtures[i].status == 1) {

          let updatedFixture = await seasonsInstance.updateStatus(activeSeasonId, activeGameweek, activeFixtures[i].id, 2);

          let votingPeriodOverDuration : Timer.Duration = #nanoseconds(Int.abs((Time.now() + EventData_VotingPeriod) - Time.now()));

          if (not Buffer.contains<Int>(timerCreatedTimes, updatedFixture.kickOff, Int.equal)) {
            switch (setAndBackupTimer) {
              case (null) {};
              case (?actualFunction) {
                await actualFunction(votingPeriodOverDuration, "votingPeriodOverExpired", activeFixtures[i].id);
                timerCreatedTimes.add(updatedFixture.kickOff);
              };
            };
          };
        };
      };

      await updateCacheHash("fixtures");
    };

    public func fixtureConsensusReached(seasonId : T.SeasonId, gameweekNumber : T.GameweekNumber, fixtureId : T.FixtureId, consensusPlayerEventData : [T.PlayerEventData]) : async () {
      var getSeasonId = seasonId;
      if (getSeasonId == 0) {
        getSeasonId := activeSeasonId;
      };

      var getGameweekNumber = gameweekNumber;
      if (getGameweekNumber == 0) {
        getGameweekNumber := activeGameweek;
      };

      if (interestingGameweek < activeGameweek) {
        interestingGameweek := activeGameweek;
      };

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);

      for (i in Iter.range(0, Array.size(activeFixtures) -1)) {
        let fixture = activeFixtures[i];
        if (fixture.id == fixtureId and fixture.status == 2) {
          let updatedFixture = await seasonsInstance.savePlayerEventData(getSeasonId, getGameweekNumber, activeFixtures[i].id, List.fromArray(consensusPlayerEventData));
          await finaliseFixture(updatedFixture);
        };
      };

      await checkGameweekFinished();
      await updateCacheHash("fixtures");
      await updateCacheHash("weekly_leaderboard");
      await updateCacheHash("monthly_leaderboards");
      await updateCacheHash("season_leaderboard");
      await updateCacheHash("system_state");
      await updatePlayerEventDataCache();
    };

    public func finaliseFixture(fixture : T.Fixture) : async () {
      let fixtureWithHighestPlayerId = await calculatePlayerScores(activeSeasonId, activeGameweek, fixture);
      await seasonsInstance.updateHighestPlayerId(activeSeasonId, activeGameweek, fixtureWithHighestPlayerId);
      await calculateFantasyTeamScores(activeSeasonId, activeGameweek);
    };

    private func checkGameweekFinished() : async () {
      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
      let remainingFixtures = Array.find(
        activeFixtures,
        func(fixture : T.Fixture) : Bool {
          return fixture.status < 3;
        },
      );

      if (Option.isNull(remainingFixtures)) {
        await gameweekVerified();
        await setNextGameweek();
      };
    };

    private func gameweekVerified() : async () {
      //await distributeRewards(); //IMPLEMENT POST SNS
    };

    public func setNextGameweek() : async () {
      if (activeGameweek == 38) {
        await seasonsInstance.createNewSeason(activeSeasonId);
        await resetFantasyTeams();
        await updateCacheHash("system_state");
        await updateCacheHash("weekly_leaderboard");
        await updateCacheHash("monthly_leaderboards");
        await updateCacheHash("season_leaderboard");
        return;
      };

      activeGameweek += 1;

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);

      let gameweekBeginDuration : Timer.Duration = #nanoseconds(Int.abs(activeFixtures[0].kickOff - Time.now() - oneHour));
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(gameweekBeginDuration, "gameweekBeginExpired", 0);
        };
      };
    };

    public func intialFixturesConfirmed() : async () {
      activeGameweek := 1;
      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);

      let initialGameweekBeginDuration : Timer.Duration = #nanoseconds(Int.abs(activeFixtures[0].kickOff - Time.now() - oneHour));
      switch (setAndBackupTimer) {
        case (null) {};
        case (?actualFunction) {
          await actualFunction(initialGameweekBeginDuration, "gameweekBeginExpired", 0);
        };
      };
    };

    public func getSeason(seasonId : T.SeasonId) : T.Season {
      return seasonsInstance.getSeason(seasonId);
    };

    public func getActiveSeason() : T.Season {
      return seasonsInstance.getSeason(activeSeasonId);
    };

    public func getActiveSeasonId() : Nat16 {
      return activeSeasonId;
    };

    public func getActiveGameweek() : Nat8 {
      return activeGameweek;
    };

    public func getInterestingGameweek() : Nat8 {
      return interestingGameweek;
    };

    public func getFixtures() : [T.Fixture] {
      return seasonsInstance.getSeasonFixtures(activeSeasonId);
    };

    public func getFixturesForSeason(seasonId : T.SeasonId) : [T.Fixture] {
      return seasonsInstance.getSeasonFixtures(seasonId);
    };

    public func getGameweekFixtures(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : [T.Fixture] {
      return seasonsInstance.getGameweekFixtures(seasonId, gameweek);
    };

    public func getActiveGameweekFixtures() : [T.Fixture] {
      return seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
    };

    public func getSeasons() : [T.Season] {
      return seasonsInstance.getSeasons();
    };

    public func addInitialFixtures(seasonId : T.SeasonId, fixtures : [T.Fixture]) : async () {
      seasonsInstance.addInitialFixtures(seasonId, fixtures);
    };

    public func rescheduleFixture(fixtureId : T.FixtureId, currentFixtureGameweek : T.GameweekNumber, updatedFixtureGameweek : T.GameweekNumber, updatedFixtureDate : Int) : async () {

      var allSeasons = List.fromArray(seasonsInstance.getSeasons());
      allSeasons := List.map<T.Season, T.Season>(
        allSeasons,
        func(currentSeason : T.Season) : T.Season {
          if (currentSeason.id == activeSeasonId) {
            var updatedGameweeks : List.List<T.Gameweek> = List.nil();
            var postponedFixtures : List.List<T.Fixture> = List.nil();

            for (gameweek in Iter.fromList(currentSeason.gameweeks)) {
              let postponedFixture = List.find<T.Fixture>(
                gameweek.fixtures,
                func(fixture : T.Fixture) : Bool {
                  return fixture.id == fixtureId;
                },
              );

              switch (postponedFixture) {
                case (null) {};
                case (?foundPostponedFixture) {
                  postponedFixtures := List.push(foundPostponedFixture, currentSeason.postponedFixtures);
                };
              };
            };

            updatedGameweeks := List.map<T.Gameweek, T.Gameweek>(
              currentSeason.gameweeks,
              func(gw : T.Gameweek) : T.Gameweek {
                if (gw.number == currentFixtureGameweek) {
                  return {
                    canisterId = gw.canisterId;
                    number = gw.number;
                    fixtures = List.filter<T.Fixture>(
                      gw.fixtures,
                      func(fixture : T.Fixture) : Bool {
                        return fixture.id != fixtureId;
                      },
                    );
                  };
                } else { return gw };
              },
            );

            let updatedSeason : T.Season = {
              id = currentSeason.id;
              name = currentSeason.name;
              year = currentSeason.year;
              gameweeks = updatedGameweeks;
              postponedFixtures = postponedFixtures;
            };

            return updatedSeason;
          } else {
            return currentSeason;
          };
        },
      );
      seasonsInstance.setSeasons(List.toArray(allSeasons));
    };

    public func setTimerBackupFunction(_setAndBackupTimer : (duration : Timer.Duration, callbackName : Text, fixtureId : T.FixtureId) -> async ()) {
      setAndBackupTimer := ?_setAndBackupTimer;
    };

    public func getFixture(seasonId : T.SeasonId, gameweekNumber : T.GameweekNumber, fixtureId : T.FixtureId) : async T.Fixture {

      var getSeasonId = seasonId;
      if (getSeasonId == 0) {
        getSeasonId := activeSeasonId;
      };

      var getGameweekNumber = gameweekNumber;
      if (getGameweekNumber == 0) {
        getGameweekNumber := activeGameweek;
      };

      return await seasonsInstance.getFixture(getSeasonId, getGameweekNumber, fixtureId);
    };

    /*Remove these functions post sns*/

    public func updateFixture(updatedFixture : DTOs.UpdateFixtureDTO) : async () {
      await seasonsInstance.updateFixture(updatedFixture);
    };

    public func updateSystemState(systemState : DTOs.UpdateSystemStateDTO) : async Result.Result<(), T.Error> {
      activeGameweek := systemState.activeGameweek;
      interestingGameweek := systemState.focusGameweek;
      return #ok;
    };

    public func updateFixtureStatus(fixtureId : T.FixtureId, status : Nat8) : async () {
      let updatedFixture = await seasonsInstance.updateStatus(activeSeasonId, activeGameweek, fixtureId, status);
    };

    public func postPoneFixtuure() {
      seasonsInstance.postPoneFixtuure();
    };






  };
};
