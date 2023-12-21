import T "types";
import DTOs "DTOs";
import Timer "mo:base/Timer";
import { now } = "mo:base/Time";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import List "mo:base/List";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import SnapshotManager "patterns/snapshot-manager";
import SnapshotFactory "patterns/snapshot-factory";
import PlayerComposite "patterns/player-composite";
import ClubComposite "patterns/club-composite";
import StrategyManager "patterns/strategy-manager";
import ManagerProfileManager "patterns/manager-profile-manager";
import Utilities "utilities";

module {

  public class SeasonManager(setAndBackupTimer : (duration : Timer.Duration, timerInfo: T.TimerInfo) -> async ()) {

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

    let former_players_canister = actor (CANISTER_IDS.former_players_canister) : actor {
      getFormerPlayer : (playerId: T.PlayerId) -> async ();
      addFormerPlayer : (playerDTO: DTOs.PlayerDTO) -> async ();
      reinstateFormerPlayer : (playerId: T.PlayerId) -> async ();
    };

    let retired_players_canister = actor (CANISTER_IDS.retired_players_canister) : actor {
      getRetiredPlayer : (playerId: T.PlayerId) -> async ();
      retirePlayer : (playerDTO: DTOs.PlayerDTO) -> async ();
      unretirePlayer : (playerId: T.PlayerId) -> async ();
    };

    private var systemState: T.SystemState = {
      calculationGameweek = 1;
      calculationMonth = 8;
      calculationSeason = 1;
      pickTeamGameweek = 1;
      homepageFixturesGameweek = 1;
      homepageManagerGameweek = 0;
    };

    private var dataCacheHashes : List.List<T.DataCache> = List.fromArray([
      { category = "clubs"; hash = "DEFAULT_VALUE" },
      { category = "fixtures"; hash = "DEFAULT_VALUE" },
      { category = "weekly_leaderboard"; hash = "DEFAULT_VALUE" },
      { category = "monthly_leaderboards"; hash = "DEFAULT_VALUE" },
      { category = "season_leaderboard"; hash = "DEFAULT_VALUE" },
      { category = "players"; hash = "DEFAULT_VALUE" },
      { category = "player_events"; hash = "DEFAULT_VALUE" }
    ]);

    private var nextClubId : T.ClubId = 1;
    private var nextPlayerId : T.PlayerId = 1;
    private var nextSeasonId : T.SeasonId = 1;
    private var nextFixtureId : T.FixtureId = 1;
    private var managers: HashMap.HashMap<T.PrincipalId, T.Manager> = HashMap.HashMap<T.PrincipalId, T.Manager>(100, Text.equal, Text.hash);
    private var players = List.fromArray<T.Player>([]);
    private var seasons = List.fromArray<T.Season>([]);
    private var profilePictureCanisterIds : HashMap.HashMap<T.PrincipalId, Text> = HashMap.HashMap<T.PrincipalId, Text>(100, Text.equal, Text.hash);    

    private var seasonLeaderboardCanisterIds : HashMap.HashMap<T.SeasonId, Text> = HashMap.HashMap<T.SeasonId, Text>(100, Utilities.eqNat16, Utilities.hashNat16);
    private var monthlyLeaderboardCanisterIds : HashMap.HashMap<T.MonthlyLeaderboardKey, Text> = HashMap.HashMap<T.MonthlyLeaderboardKey, Text>(100, Utilities.eqMonthlyKey, Utilities.hashMonthlyKey);
    private var weeklyLeaderboardCanisterIds : HashMap.HashMap<T.WeeklyLeaderboardKey, Text> = HashMap.HashMap<T.WeeklyLeaderboardKey, Text>(100, Utilities.eqWeeklyKey, Utilities.hashWeeklyKey);

    public func setStableData(
      stable_system_state : T.SystemState,
      stable_data_cache_hashes: [T.DataCache],
      stable_next_club_id: T.ClubId,
      stable_next_player_id: T.PlayerId,
      stable_next_season_id: T.SeasonId,
      stable_next_fixture_id: T.FixtureId,
      stable_managers: [(T.PrincipalId, T.Manager)],
      stable_players: [T.Player],
      stable_seasons: [T.Season],
      stable_profile_picture_canister_ids:  [(T.PrincipalId, Text)],
      stable_season_leaderboard_canister_ids:  [(T.SeasonId, Text)],
      stable_monthly_leaderboard_canister_ids:  [(T.MonthlyLeaderboardKey, Text)],
      stable_weekly_leaderboard_canister_ids:  [(T.WeeklyLeaderboardKey, Text)]) {

      systemState := stable_system_state;
      dataCacheHashes := List.fromArray(stable_data_cache_hashes);
      nextClubId := stable_next_club_id;
      nextPlayerId := stable_next_player_id;
      nextSeasonId := stable_next_season_id;
      nextFixtureId := stable_next_fixture_id;
       
      managers := HashMap.fromIter<T.PrincipalId, T.Manager>(
        stable_managers.vals(),
        stable_managers.size(),
        Text.equal,
        Text.hash,
      );

      players := List.fromArray(stable_players);
      seasons := List.fromArray(stable_seasons);

      profilePictureCanisterIds := HashMap.fromIter<T.PrincipalId, Text>(
        stable_profile_picture_canister_ids.vals(),
        stable_profile_picture_canister_ids.size(),
        Text.equal,
        Text.hash,
      );

      seasonLeaderboardCanisterIds := HashMap.fromIter<T.SeasonId, Text>(
        stable_season_leaderboard_canister_ids.vals(),
        stable_season_leaderboard_canister_ids.size(),
        Utilities.eqNat16, 
        Utilities.hashNat16
      );

      monthlyLeaderboardCanisterIds := HashMap.fromIter<T.MonthlyLeaderboardKey, Text>(
        stable_monthly_leaderboard_canister_ids.vals(),
        stable_monthly_leaderboard_canister_ids.size(),
        Utilities.eqMonthlyKey, 
        Utilities.hashMonthlyKey
      );

      weeklyLeaderboardCanisterIds := HashMap.fromIter<T.WeeklyLeaderboardKey, Text>(
        stable_weekly_leaderboard_canister_ids.vals(),
        stable_weekly_leaderboard_canister_ids.size(),
        Utilities.eqWeeklyKey, 
        Utilities.hashWeeklyKey
      );
      
    };










      /* 
      


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






    //recreate close gameweek timer to be 1 hour before the first fixture of the gameweek you are picking your team for

    //recreate the jan transfer window timer to the next January 1st

    //recreate the close jan transfer window timer for midnight on the 31st Jan

    //recreate timers for active games that are counting down to move a game from inactive to active or active to completed















      */

    //Callback functions called by main canister observer:

    public func gameweekBegin() : async () {

      //snapshot manager / snapshot factory create snapshots of the fantasy teams as the current gameweek
      //manager profile manager resets a users transfers






      //await snapshotGameweek(systemState.calculationSeason, systemState.calculationGameweek);
      //await resetTransfers();

    };

    
    public func gameKickOff() : async () {

      //set fixture status to active (1)
      
      //set timers for when each game finishes to call the game completed expired timer


      /*
      let activeFixtures = seasonsInstance.getGameweekFixtures(systemState.calculationSeason, systemState.calculationGameweek);
      for (i in Iter.range(0, Array.size(activeFixtures) -1)) {
        if (activeFixtures[i].kickOff <= Time.now() and activeFixtures[i].status == 0) {

          let updatedFixture = await seasonsInstance.updateStatus(systemState.calculationSeason, systemState.calculationGameweek, activeFixtures[i].id, 1);
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
      */
    };

    
    public func gameCompleted() : async () {
      //update fixture status to complete (2) so proposals for the fixture data can be entered
      //update the cache for the fixtures so users get the updated status about it being completed

      //    let updatedFixture = await seasonsInstance.updateStatus(systemState.calculationSeason, systemState.calculationGameweek, activeFixtures[i].id, 2);
      //await updateCacheHash("fixtures");

      //Check if all games completed, if so:
        //NEED TO CHECK IF JANUARY 1ST IS IN THE UPCOMING GAMEWEEK THEN SET A TIMERS TO BEGIN AND END THE TRANSFER WINDOW IF IT IS
        
    };

    public func loanExpiredCallback() : async () {
      //when a player on loan has been on load for their loan duration bring them back
      
      //executeRecallPlayer();
    };

    
    public func transferWindowStartCallback() : async () {
      //SETUP THE JAN TRANSFER WINDOW
    };
    
    public func transferWindowEndCallback() : async () {
      //END THE JAN TRANSFER WINDOW
    };
    

    public func getSystemState() : async DTOs.SystemStateDTO {
      return systemState;
    };
    
    public func getDataHashes() : [DTOs.DataCacheDTO] {
      return List.toArray(dataCacheHashes);
    };
    
    public func getFixtures(seasonId: T.SeasonId) : [DTOs.FixtureDTO] {
      return [];
    };
    
    public func getPlayers() : [DTOs.PlayerDTO] {
      return [];
    };

    public func getDetailedPlayers(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : [DTOs.PlayerDTO] {
      return [];
    };

    public func getWeeklyLeaderboard(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      let leaderboardKey: T.WeeklyLeaderboardKey = (seasonId, gameweek);
      let canisterId = weeklyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let weekly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : () -> async DTOs.WeeklyLeaderboardDTO;
          };

          let leaderboardEntries = await weekly_leaderboard_canister.getEntries();
          return #ok(leaderboardEntries);
        };
      };
    };
    
    public func getMonthlyLeaderboard(seasonId: T.SeasonId, month: T.CalendarMonth, clubId: T.ClubId) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error>{
      let leaderboardKey: T.MonthlyLeaderboardKey = (seasonId, month, clubId);
      let canisterId = monthlyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let monthly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : () -> async DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries();
          return #ok(leaderboardEntries);
        };
      };
    };

    public func getSeasonLeaderboard(seasonId: T.SeasonId) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error>{
      let seasonCanisterId = seasonLeaderboardCanisterIds.get(seasonId);
      switch(seasonCanisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundSeasonCanisterId){
          let season_leaderboard_canister = actor (foundSeasonCanisterId) : actor {
            getEntries : () -> async DTOs.SeasonLeaderboardDTO;
          };

          let leaderboardEntries = await season_leaderboard_canister.getEntries();
          return #ok(leaderboardEntries);
        };
      };
    };
    
    public func getProfile(principalId: Text){

    };
    
    public func getManager(principalId: Text){

    };
    
    public func getTotalManagers(){

      //fantasyTeams.size();

    };
    
    public func isUsernameAvailable(username: Text){

    };

    public func seasonActive() : Bool {
/*
      if (activeGameweek > 1) {
        return true;
      };

      let activeFixtures = seasonsInstance.getGameweekFixtures(activeSeasonId, activeGameweek);
      if (List.some(List.fromArray(activeFixtures), func(fixture : T.Fixture) : Bool { return fixture.status > 0 })) {
        return true;
      };*/

      return false;
    };

    /* Incorporate all this with the save fantasy team function as I should only need 1
    public func createFantasyTeam(principalId : Text, teamName : Text, favouriteTeamId : T.TeamId, gameweek : Nat8, newPlayers : [DTOs.PlayerDTO], captainId : Nat16, bonusId : Nat8, bonusPlayerId : Nat16, bonusTeamId : Nat16) : Result.Result<(), T.Error> {

      let existingTeam = fantasyTeams.get(principalId);

      switch (existingTeam) {
        case (null) {

          let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(newPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.value });

          if (not isTeamValid(newPlayers, bonusId, bonusPlayerId)) {
            return #err(#InvalidTeamError);
          };

          let totalTeamValue = Array.foldLeft<Nat, Nat>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);

          if (totalTeamValue > 1200) {
            return #err(#InvalidTeamError);
          };

          let bank : Nat = 1200 - totalTeamValue;

          var bankBalance = bank;
          var goalGetterGameweek = Nat8.fromNat(0);
          var goalGetterPlayerId = Nat16.fromNat(0);
          var passMasterGameweek = Nat8.fromNat(0);
          var passMasterPlayerId = Nat16.fromNat(0);
          var noEntryGameweek = Nat8.fromNat(0);
          var noEntryPlayerId = Nat16.fromNat(0);
          var teamBoostGameweek = Nat8.fromNat(0);
          var teamBoostTeamId = Nat16.fromNat(0);
          var safeHandsGameweek = Nat8.fromNat(0);
          var captainFantasticGameweek = Nat8.fromNat(0);

          var countrymenGameweek = Nat8.fromNat(0);
          var countrymenCountryId = Nat16.fromNat(0);
          var prospectsGameweek = Nat8.fromNat(0);
          var braceBonusGameweek = Nat8.fromNat(0);
          var hatTrickHeroGameweek = Nat8.fromNat(0);
          var newCaptainId = captainId;

          let sortedPlayers = sortPlayers(newPlayers);
          let allPlayerIds = Array.map<DTOs.PlayerDTO, Nat16>(sortedPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.id });

          if (newCaptainId == 0) {
            var highestValue = 0;
            for (i in Iter.range(0, Array.size(newPlayers) -1)) {
              if (newPlayers[i].value > highestValue) {
                highestValue := newPlayers[i].value;
                newCaptainId := newPlayers[i].id;
              };
            };
          };

          if (bonusId == 1 and bonusPlayerId > 0) {
            goalGetterGameweek := gameweek;
            goalGetterPlayerId := bonusPlayerId;
          };

          if (bonusId == 2 and bonusPlayerId > 0) {
            passMasterGameweek := gameweek;
            passMasterPlayerId := bonusPlayerId;
          };

          if (bonusId == 3 and bonusPlayerId > 0) {
            noEntryGameweek := gameweek;
            noEntryPlayerId := bonusPlayerId;
          };

          if (bonusId == 4 and bonusTeamId > 0) {
            teamBoostGameweek := gameweek;
            teamBoostTeamId := bonusTeamId;
          };

          if (bonusId == 5) {
            safeHandsGameweek := gameweek;
          };

          if (bonusId == 6) {
            captainFantasticGameweek := gameweek;
          };

          if (bonusId == 7) {
            prospectsGameweek := gameweek;
          };

          if (bonusId == 8) {
            countrymenGameweek := gameweek;
            countrymenCountryId := bonusPlayerId;
          };

          if (bonusId == 9) {
            braceBonusGameweek := gameweek;
          };

          if (bonusId == 10) {
            hatTrickHeroGameweek := gameweek;
          };

          var captainFantasticPlayerId : T.PlayerId = 0;
          var safeHandsPlayerId : T.PlayerId = 0;

          if (captainFantasticGameweek == gameweek) {
            captainFantasticPlayerId := newCaptainId;
          };

          if (safeHandsGameweek == gameweek) {

            let goalKeeper = List.find<DTOs.PlayerDTO>(
              List.fromArray(sortedPlayers),
              func(player : DTOs.PlayerDTO) : Bool {
                return player.position == 0;
              },
            );

            switch (goalKeeper) {
              case (null) {};
              case (?gk) {
                safeHandsPlayerId := gk.id;
              };
            };
          };

          var newTeam : T.FantasyTeam = {
            principalId = principalId;
            bankBalance = bankBalance;
            playerIds = allPlayerIds;
            transfersAvailable = 3;
            transferWindowGameweek = 0;
            captainId = newCaptainId;
            goalGetterGameweek = goalGetterGameweek;
            goalGetterPlayerId = goalGetterPlayerId;
            passMasterGameweek = passMasterGameweek;
            passMasterPlayerId = passMasterPlayerId;
            noEntryGameweek = noEntryGameweek;
            noEntryPlayerId = noEntryPlayerId;
            teamBoostGameweek = teamBoostGameweek;
            teamBoostTeamId = teamBoostTeamId;
            safeHandsGameweek = safeHandsGameweek;
            safeHandsPlayerId = safeHandsPlayerId;
            captainFantasticGameweek = captainFantasticGameweek;
            captainFantasticPlayerId = captainFantasticPlayerId;
            countrymenGameweek = countrymenGameweek;
            countrymenCountryId = countrymenCountryId;
            prospectsGameweek = prospectsGameweek;
            braceBonusGameweek = braceBonusGameweek;
            hatTrickHeroGameweek = hatTrickHeroGameweek;
            teamName = teamName;
            favouriteTeamId = favouriteTeamId;
          };

          let newUserTeam : T.UserFantasyTeam = {
            fantasyTeam = newTeam;
            history = List.nil<T.FantasyTeamSeason>();
          };

          fantasyTeams.put(principalId, newUserTeam);
          return #ok(());
        };
        case (?existingTeam) { return #ok(()) };
      };
    };


    public func updateFantasyTeam(principalId : Text, newPlayers : [DTOs.PlayerDTO], captainId : Nat16, bonusId : Nat8, bonusPlayerId : Nat16, bonusTeamId : Nat16, gameweek : Nat8, existingPlayers : [DTOs.PlayerDTO], transferWindowGameweek: T.GameweekNumber) : async Result.Result<(), T.Error> {

      let existingUserTeam = fantasyTeams.get(principalId);
      switch (existingUserTeam) {
        case (null) { return #ok(()) };
        case (?e) {
          let existingTeam = e.fantasyTeam;
          let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat>(newPlayers, func(player : DTOs.PlayerDTO) : Nat { return player.value });

          if (not isTeamValid(newPlayers, bonusId, bonusPlayerId)) {
            return #err(#InvalidTeamError);
          };

          let playersAdded = Array.filter<DTOs.PlayerDTO>(
            newPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              let playerId = player.id;
              let isPlayerIdInExistingTeam = Array.find(
                existingTeam.playerIds,
                func(id : Nat16) : Bool {
                  return id == playerId;
                },
              );
              return Option.isNull(isPlayerIdInExistingTeam);
            },
          );

          if(existingTeam.transferWindowGameweek != gameweek and gameweek != 1 and Nat8.fromNat(Array.size(playersAdded)) > existingTeam.transfersAvailable){
            return #err(#InvalidTeamError);
          };

          let playersRemoved = Array.filter<Nat16>(
            existingTeam.playerIds,
            func(playerId : Nat16) : Bool {
              let isPlayerIdInPlayers = Array.find(
                newPlayers,
                func(player : DTOs.PlayerDTO) : Bool {
                  return player.id == playerId;
                },
              );
              return Option.isNull(isPlayerIdInPlayers);
            },
          );

          let spent = Array.foldLeft<DTOs.PlayerDTO, Nat>(playersAdded, 0, func(sumSoFar, x) = sumSoFar + x.value);
          var sold : Nat = 0;
          for (i in Iter.range(0, Array.size(playersRemoved) -1)) {
            let newPlayer = await getPlayer(playersRemoved[i]);
            sold := sold + newPlayer.value;
          };

          let netSpendQMs : Int = spent - sold;

          if (netSpendQMs > existingTeam.bankBalance) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 1 and existingTeam.goalGetterGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 2 and existingTeam.passMasterGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 3 and existingTeam.noEntryGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 4 and existingTeam.teamBoostGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 5 and existingTeam.safeHandsGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 6 and existingTeam.captainFantasticGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 7 and existingTeam.braceBonusGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (bonusId == 8 and existingTeam.hatTrickHeroGameweek != 0) {
            return #err(#InvalidTeamError);
          };

          if (
            bonusId > 0 and (
              existingTeam.goalGetterGameweek == gameweek or existingTeam.passMasterGameweek == gameweek or existingTeam.noEntryGameweek == gameweek or existingTeam.teamBoostGameweek == gameweek or existingTeam.safeHandsGameweek == gameweek or existingTeam.captainFantasticGameweek == gameweek or existingTeam.braceBonusGameweek == gameweek or existingTeam.hatTrickHeroGameweek == gameweek,
            ),
          ) {
            return #err(#InvalidTeamError);
          };

          var goalGetterGameweek = existingTeam.goalGetterGameweek;
          var goalGetterPlayerId = existingTeam.goalGetterPlayerId;
          var passMasterGameweek = existingTeam.passMasterGameweek;
          var passMasterPlayerId = existingTeam.passMasterPlayerId;
          var noEntryGameweek = existingTeam.noEntryGameweek;
          var noEntryPlayerId = existingTeam.noEntryPlayerId;
          var teamBoostGameweek = existingTeam.teamBoostGameweek;
          var teamBoostTeamId = existingTeam.teamBoostTeamId;
          var safeHandsGameweek = existingTeam.safeHandsGameweek;
          var captainFantasticGameweek = existingTeam.captainFantasticGameweek;

          var countrymenGameweek = existingTeam.countrymenGameweek;
          var countrymenCountryId = existingTeam.countrymenCountryId;
          var prospectsGameweek = existingTeam.prospectsGameweek;

          var braceBonusGameweek = existingTeam.braceBonusGameweek;
          var hatTrickHeroGameweek = existingTeam.hatTrickHeroGameweek;
          var newCaptainId = captainId;

          let sortedPlayers = sortPlayers(newPlayers);
          let allPlayerIds = Array.map<DTOs.PlayerDTO, Nat16>(sortedPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.id });

          if (newCaptainId == 0) {
            var highestValue = 0;
            for (i in Iter.range(0, Array.size(newPlayers) -1)) {
              if (newPlayers[i].value > highestValue) {
                highestValue := newPlayers[i].value;
                newCaptainId := newPlayers[i].id;
              };
            };
          };

          if (bonusId == 1 and bonusPlayerId > 0) {
            goalGetterGameweek := gameweek;
            goalGetterPlayerId := bonusPlayerId;
          };

          if (bonusId == 2 and bonusPlayerId > 0) {
            passMasterGameweek := gameweek;
            passMasterPlayerId := bonusPlayerId;
          };

          if (bonusId == 3 and bonusPlayerId > 0) {
            noEntryGameweek := gameweek;
            noEntryPlayerId := bonusPlayerId;
          };

          if (bonusId == 4 and bonusTeamId > 0) {
            teamBoostGameweek := gameweek;
            teamBoostTeamId := bonusTeamId;
          };

          if (bonusId == 5) {
            safeHandsGameweek := gameweek;
          };

          if (bonusId == 6) {
            captainFantasticGameweek := gameweek;
          };

          if (bonusId == 7) {
            braceBonusGameweek := gameweek;
          };

          if (bonusId == 8) {
            hatTrickHeroGameweek := gameweek;
          };

          let newBankBalance : Int = existingTeam.bankBalance - netSpendQMs;

          if (newBankBalance < 0) {
            return #err(#InvalidTeamError);
          };

          let natBankBalance : Nat = Nat16.toNat(Int16.toNat16(Int16.fromInt(newBankBalance)));


          //check if january transfer window played, only allow if
            //not already played 
            //it's for a week which is in january
            //if valid can skip the transfers available check
            //ensure that you set that it's been used


          //if not played do standard transfer checks


          var newTransfersAvailable : Nat8 = 3;

          if (gameweek != 1 and existingTeam.transferWindowGameweek != gameweek) {
            newTransfersAvailable := existingTeam.transfersAvailable - Nat8.fromNat(Array.size(playersAdded));
          };

          var captainFantasticPlayerId : T.PlayerId = 0;
          var safeHandsPlayerId : T.PlayerId = 0;

          if (captainFantasticGameweek == gameweek) {
            captainFantasticPlayerId := newCaptainId;
          };

          if (safeHandsGameweek == gameweek) {

            let goalKeeper = List.find<DTOs.PlayerDTO>(
              List.fromArray(sortedPlayers),
              func(player : DTOs.PlayerDTO) : Bool {
                return player.position == 0;
              },
            );

            switch (goalKeeper) {
              case (null) {};
              case (?gk) {
                safeHandsPlayerId := gk.id;
              };
            };
          };

          let updatedTeam : T.FantasyTeam = {
            principalId = principalId;
            bankBalance = natBankBalance;
            playerIds = allPlayerIds;
            transfersAvailable = newTransfersAvailable;
            transferWindowGameweek = transferWindowGameweek;
            captainId = newCaptainId;
            goalGetterGameweek = goalGetterGameweek;
            goalGetterPlayerId = goalGetterPlayerId;
            passMasterGameweek = passMasterGameweek;
            passMasterPlayerId = passMasterPlayerId;
            noEntryGameweek = noEntryGameweek;
            noEntryPlayerId = noEntryPlayerId;
            teamBoostGameweek = teamBoostGameweek;
            teamBoostTeamId = teamBoostTeamId;
            safeHandsGameweek = safeHandsGameweek;
            safeHandsPlayerId = safeHandsPlayerId;
            captainFantasticGameweek = captainFantasticGameweek;
            captainFantasticPlayerId = captainFantasticPlayerId;
            countrymenGameweek = countrymenGameweek;
            countrymenCountryId = countrymenCountryId;
            prospectsGameweek = prospectsGameweek;
            braceBonusGameweek = braceBonusGameweek;
            hatTrickHeroGameweek = hatTrickHeroGameweek;
            favouriteTeamId = existingTeam.favouriteTeamId;
            teamName = existingTeam.teamName;
          };

          let updatedUserTeam : T.UserFantasyTeam = {
            fantasyTeam = updatedTeam;
            history = e.history;
          };

          fantasyTeams.put(principalId, updatedUserTeam);
          return #ok(());
        };
      };
    };

    private func sortPlayers(players : [DTOs.PlayerDTO]) : [DTOs.PlayerDTO] {

      let sortedPlayers = Array.sort(
        players,
        func(a : DTOs.PlayerDTO, b : DTOs.PlayerDTO) : Order.Order {
          if (a.position < b.position) { return #less };
          if (a.position > b.position) { return #greater };
          if (a.value > b.value) { return #less };
          if (a.value < b.value) { return #greater };
          return #equal;
        },
      );
      return sortedPlayers;
    };

    public func isTeamValid(players : [DTOs.PlayerDTO], bonusId : Nat8, bonusPlayerId : Nat16) : Bool {
      let playerPositions = Array.map<DTOs.PlayerDTO, Nat8>(players, func(player : DTOs.PlayerDTO) : Nat8 { return player.position });

      let playerCount = playerPositions.size();
      if (playerCount != 11) {
        return false;
      };

      var teamPlayerCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
      var playerIdCounts = HashMap.HashMap<Text, Nat8>(0, Text.equal, Text.hash);
      var goalkeeperCount = 0;
      var defenderCount = 0;
      var midfielderCount = 0;
      var forwardCount = 0;

      for (i in Iter.range(0, playerCount -1)) {
        let count = teamPlayerCounts.get(Nat16.toText(players[i].teamId));
        switch (count) {
          case (null) {
            teamPlayerCounts.put(Nat16.toText(players[i].teamId), 1);
          };
          case (?count) {
            teamPlayerCounts.put(Nat16.toText(players[i].teamId), count + 1);
          };
        };

        let playerIdCount = playerIdCounts.get(Nat16.toText(players[i].id));
        switch (playerIdCount) {
          case (null) { playerIdCounts.put(Nat16.toText(players[i].id), 1) };
          case (?count) {
            return false;
          };
        };

        if (players[i].position == 0) {
          goalkeeperCount += 1;
        };

        if (players[i].position == 1) {
          defenderCount += 1;
        };

        if (players[i].position == 2) {
          midfielderCount += 1;
        };

        if (players[i].position == 3) {
          forwardCount += 1;
        };

      };

      for ((key, value) in teamPlayerCounts.entries()) {
        if (value > 2) {
          return false;
        };
      };

      if (
        goalkeeperCount != 1 or defenderCount < 3 or defenderCount > 5 or midfielderCount < 3 or midfielderCount > 5 or forwardCount < 1 or forwardCount > 3,
      ) {
        return false;
      };

      if (bonusId == 3) {
        let bonusPlayer = List.find<DTOs.PlayerDTO>(
          List.fromArray(players),
          func(player : DTOs.PlayerDTO) : Bool {
            return player.id == bonusPlayerId;
          },
        );
        switch (bonusPlayer) {
          case (null) { return false };
          case (?player) {
            if (player.position != 1) { return false };
          };
        };
      };

      return true;
    };

    
    public func createNewSeason(activeSeasonId : Nat16) : async () {
      let activeSeason = List.find<T.Season>(
        seasons,
        func(season : T.Season) : Bool {
          return season.id == activeSeasonId;
        },
      );

      var newSeasonsList = List.nil<T.Season>();
      switch (activeSeason) {
        case (null) {};
        case (?season) {
          let newYear = season.year + 1;
          let gameweeks : [T.Gameweek] = Array.tabulate<T.Gameweek>(
            38,
            func(index : Nat) : T.Gameweek {
              return {
                number = Nat8.fromNat(index + 1);
                canisterId = "";
                fixtures = List.nil<T.Fixture>();
              };
            },
          );

          let newSeason : T.Season = {
            id = nextSeasonId;
            name = Nat16.toText(newYear) # subText(Nat16.toText(newYear + 1), 2, 3);
            year = newYear;
            gameweeks = List.nil();
            postponedFixtures = List.nil();
          };

          newSeasonsList := List.push(newSeason, newSeasonsList);
          seasons := List.append(seasons, newSeasonsList);
          nextSeasonId += 1;
        };
      };
    };
    
    */

    public func saveFantasyTeam(principalId: Text, fantasyTeam: DTOs.UpdateFantasyTeamDTO){
/*
      let principalId = Principal.toText(caller);
      let fantasyTeam = fantasyTeamsInstance.getFantasyTeam(principalId);

      let allPlayers = await playerCanister.getPlayers();

      let newPlayers = Array.filter<DTOs.PlayerDTO>(
        allPlayers,
        func(player : DTOs.PlayerDTO) : Bool {
          let playerId = player.id;
          let isPlayerIdInNewTeam = Array.find(
            newPlayerIds,
            func(id : Nat16) : Bool {
              return id == playerId;
            },
          );
          return Option.isSome(isPlayerIdInNewTeam);
        },
      );

      let captainExists = Array.find(
        newPlayerIds,
        func(id : Nat16) : Bool {
          return id == captainId;
        },
      );

      if (not Option.isSome(captainExists)) {
        return #err(#InvalidTeamError);
      };

      var updateTransferWindowGameweek: T.GameweekNumber = 0;
      let transferWindowActive = false;
      
      if(not transferWindowActive and transferWindowGameweek > 0){

        let transferWindowPlayed = false;
        if(transferWindowPlayed){
          return #err(#InvalidTeamError);
        };

        let activeGameweek = seasonManager.getActiveGameweek();

        if(transferWindowGameweek != activeGameweek){
          return #err(#InvalidTeamError);
        };
        updateTransferWindowGameweek := activeGameweek;
      };

      var teamName = principalId;
      var favouriteTeamId : T.TeamId = 0;

      var userProfile = profilesInstance.getProfile(principalId);
      switch (userProfile) {
        case (null) {

          profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
          let newProfile = profilesInstance.getProfile(Principal.toText(caller));
          switch (newProfile) {
            case (null) {};
            case (?foundNewProfile) {
              teamName := foundNewProfile.displayName;
              favouriteTeamId := foundNewProfile.favouriteTeamId;

            };
          };
        };
        case (?foundProfile) {
          teamName := foundProfile.displayName;
          favouriteTeamId := foundProfile.favouriteTeamId;
        };
      };

      switch (fantasyTeam) {
        case (null) {
          return fantasyTeamsInstance.createFantasyTeam(principalId, teamName, favouriteTeamId, seasonManager.getActiveGameweek(), newPlayers, captainId, bonusId, bonusPlayerId, bonusTeamId);
        };
        case (?team) {

          if(team.fantasyTeam.transferWindowGameweek > 0){
            updateTransferWindowGameweek := team.fantasyTeam.transferWindowGameweek;
          };

          let existingPlayers = Array.filter<DTOs.PlayerDTO>(
            allPlayers,
            func(player : DTOs.PlayerDTO) : Bool {
              let playerId = player.id;
              let isPlayerIdInExistingTeam = Array.find(
                team.fantasyTeam.playerIds,
                func(id : Nat16) : Bool {
                  return id == playerId;
                },
              );
              return Option.isSome(isPlayerIdInExistingTeam);
            },
          );

          return await fantasyTeamsInstance.updateFantasyTeam(principalId, newPlayers, captainId, bonusId, bonusPlayerId, bonusTeamId, seasonManager.getActiveGameweek(), existingPlayers, updateTransferWindowGameweek);
        };
      };
      */
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : Bool {
      return false;// #ok();
    };

    public func executeRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
       //await playerCanister.revaluePlayerUp(playerId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
      return #ok();
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : Bool {
      return false;// #ok();
    };

    public func executeRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
      //await playerCanister.revaluePlayerDown(playerId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
      return #ok();
    };

    public func validateSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : Bool {
      /*
      let eventsBelow0 = Array.filter<T.PlayerEventData>(
      playerEvents,
      func(event : T.PlayerEventData) : Bool {
          return event.eventStartMinute < 0;
        },
      );

      if (Array.size(eventsBelow0) > 0) {
        return false;
      };

      let eventsAbove90 = Array.filter<T.PlayerEventData>(
        playerEvents,
        func(event : T.PlayerEventData) : Bool {
          return event.eventStartMinute > 90;
        },
      );

      if (Array.size(eventsAbove90) > 0) {
        return false;
      };

      let playerEventsMap : TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>> = TrieMap.TrieMap<T.PlayerId, List.List<T.PlayerEventData>>(Utilities.eqNat16, Utilities.hashNat16);

      for (playerEvent in Iter.fromArray(playerEvents)) {
        switch (playerEventsMap.get(playerEvent.playerId)) {
          case (null) {};
          case (?existingEvents) {
            playerEventsMap.put(playerEvent.playerId, List.push<T.PlayerEventData>(playerEvent, existingEvents));
          };
        };
      };

      for ((playerId, events) in playerEventsMap.entries()) {
        let redCards = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 9; // Red Card
          },
        );

        if (List.size<T.PlayerEventData>(redCards) > 1) {
          return false;
        };

        let yellowCards = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 8; // Yellow Card
          },
        );

        if (List.size<T.PlayerEventData>(yellowCards) > 2) {
          return false;
        };

        if (List.size<T.PlayerEventData>(yellowCards) == 2 and List.size<T.PlayerEventData>(redCards) != 1) {
          return false;
        };

        let assists = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 2; // Goal Assisted
          },
        );

        for (assist in Iter.fromList(assists)) {
          let goalsAtSameMinute = List.filter<T.PlayerEventData>(
            events,
            func(event : T.PlayerEventData) : Bool {
              return event.eventType == 1 and event.eventStartMinute == assist.eventStartMinute;
            },
          );

          if (List.size<T.PlayerEventData>(goalsAtSameMinute) == 0) {
            return false;
          };
        };

        let penaltySaves = List.filter<T.PlayerEventData>(
          events,
          func(event : T.PlayerEventData) : Bool {
            return event.eventType == 6;
          },
        );

        for (penaltySave in Iter.fromList(penaltySaves)) {
          let penaltyMissesAtSameMinute = List.filter<T.PlayerEventData>(
            events,
            func(event : T.PlayerEventData) : Bool {
              return event.eventType == 7 and event.eventStartMinute == penaltySave.eventStartMinute;
            },
          );

          if (List.size<T.PlayerEventData>(penaltyMissesAtSameMinute) == 0) {
            return false;
          };
        };
      };
*/
      return true;
    };

    public func executeSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
        /*
      let activeSeasonId = seasonManager.getActiveSeasonId();
      let activeGameweek = seasonManager.getActiveGameweek();
      let fixture = await seasonManager.getFixture(activeSeasonId, activeGameweek, fixtureId);
      let allPlayers = await playerCanister.getPlayers();

      let homeTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
      let awayTeamPlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

      for (event in Iter.fromArray(playerEventData)) {
        if (event.teamId == fixture.homeTeamId) {
          homeTeamPlayerIdsBuffer.add(event.playerId);
        } else if (event.teamId == fixture.awayTeamId) {
          awayTeamPlayerIdsBuffer.add(event.playerId);
        };
      };

      let homeTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);
      let awayTeamDefensivePlayerIdsBuffer = Buffer.fromArray<Nat16>([]);

      for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(homeTeamPlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            if (actualPlayer.position == 0 or actualPlayer.position == 1) {
              if (Array.find<Nat16>(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
                homeTeamDefensivePlayerIdsBuffer.add(playerId);
              };
            };
          };
        };
      };

      for (playerId in Iter.fromArray<Nat16>(Buffer.toArray(awayTeamPlayerIdsBuffer))) {
        let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
        switch (player) {
          case (null) {};
          case (?actualPlayer) {
            if (actualPlayer.position == 0 or actualPlayer.position == 1) {
              if (Array.find<Nat16>(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer), func(x : Nat16) : Bool { return x == playerId }) == null) {
                awayTeamDefensivePlayerIdsBuffer.add(playerId);
              };
            };
          };
        };
      };

      // Get goals for each team
      let homeTeamGoals = Array.filter<T.PlayerEventData>(
        playerEventData,
        func(event : T.PlayerEventData) : Bool {
          return event.teamId == fixture.homeTeamId and event.eventType == 1;
        },
      );

      let awayTeamGoals = Array.filter<T.PlayerEventData>(
        playerEventData,
        func(event : T.PlayerEventData) : Bool {
          return event.teamId == fixture.awayTeamId and event.eventType == 1;
        },
      );

      let homeTeamOwnGoals = Array.filter<T.PlayerEventData>(
        playerEventData,
        func(event : T.PlayerEventData) : Bool {
          return event.teamId == fixture.homeTeamId and event.eventType == 10;
        },
      );

      let awayTeamOwnGoals = Array.filter<T.PlayerEventData>(
        playerEventData,
        func(event : T.PlayerEventData) : Bool {
          return event.teamId == fixture.awayTeamId and event.eventType == 10;
        },
      );

      let totalHomeScored = Array.size(homeTeamGoals) + Array.size(awayTeamOwnGoals);
      let totalAwayScored = Array.size(awayTeamGoals) + Array.size(homeTeamOwnGoals);

      let allPlayerEventsBuffer = Buffer.fromArray<T.PlayerEventData>(playerEventData);

      if (totalHomeScored == 0) {
        //add away team clean sheets
        for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let cleanSheetEvent : T.PlayerEventData = {
                fixtureId = fixtureId;
                playerId = playerId;
                eventType = 5;
                eventStartMinute = 90;
                eventEndMinute = 90;
                teamId = actualPlayer.teamId;
                position = actualPlayer.position;
              };
              allPlayerEventsBuffer.add(cleanSheetEvent);
            };
          };
        };
      } else {
        //add away team conceded events
        for (goal in Iter.fromArray(homeTeamGoals)) {
          for (playerId in Iter.fromArray(Buffer.toArray(awayTeamDefensivePlayerIdsBuffer))) {
            let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
            switch (player) {
              case (null) {};
              case (?actualPlayer) {
                let concededEvent : T.PlayerEventData = {
                  fixtureId = fixtureId;
                  playerId = actualPlayer.id;
                  eventType = 3;
                  eventStartMinute = goal.eventStartMinute;
                  eventEndMinute = goal.eventStartMinute;
                  teamId = actualPlayer.teamId;
                  position = actualPlayer.position;
                };
                allPlayerEventsBuffer.add(concededEvent);
              };
            };
          };
        };
      };

      if (totalAwayScored == 0) {
        //add home team clean sheets
        for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
          let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
          switch (player) {
            case (null) {};
            case (?actualPlayer) {
              let cleanSheetEvent : T.PlayerEventData = {
                fixtureId = fixtureId;
                playerId = playerId;
                eventType = 5;
                eventStartMinute = 90;
                eventEndMinute = 90;
                teamId = actualPlayer.teamId;
                position = actualPlayer.position;
              };
              allPlayerEventsBuffer.add(cleanSheetEvent);
            };
          };
        };
      } else {
        //add home team conceded events
        for (goal in Iter.fromArray(awayTeamGoals)) {
          for (playerId in Iter.fromArray(Buffer.toArray(homeTeamDefensivePlayerIdsBuffer))) {
            let player = Array.find<DTOs.PlayerDTO>(allPlayers, func(p : DTOs.PlayerDTO) : Bool { return p.id == playerId });
            switch (player) {
              case (null) {};
              case (?actualPlayer) {
                let concededEvent : T.PlayerEventData = {
                  fixtureId = goal.fixtureId;
                  playerId = actualPlayer.id;
                  eventType = 3;
                  eventStartMinute = goal.eventStartMinute;
                  eventEndMinute = goal.eventStartMinute;
                  teamId = actualPlayer.teamId;
                  position = actualPlayer.position;
                };
                allPlayerEventsBuffer.add(concededEvent);
              };
            };
          };
        };
         let fixtureEvents = Buffer.toArray(allPlayerEventsBuffer);
      await seasonManager.fixtureConsensusReached(fixture.seasonId, fixture.gameweek, fixtureId, fixtureEvents);
      return #ok();


      //IN HERE IF THE GAMEWEEK IS COMPLETE CREATE THE CANISTER FOR THE NEXT GAMEWEEK LEADERBOARD
      //IN HERE IF THE MONTH IS COMPLETE CREATE THE CANISTERS FOR THE NEXT MONTHS CLUB LEADERBOARDS
      //IN HERE IF THE SEASON IS COMPLETE CRAETE THE CANISTER FOR THE NEXT SEASON LEADERBOARD


*/return #ok();
    };
     
     

    public func validateAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
      /*
      let findIndex = func(arr : [T.TeamId], value : T.TeamId) : ?Nat {
        for (i in Array.keys(arr)) {
          if (arr[i] == value) {
            return ?(i);
          };
        };
        return null;
      };

      //there should be no fixtures for the season currently
      let currentSeason = seasonManager.getSeason(seasonId);
      if (currentSeason.id == 0) {
        return #err(#InvalidData);
      };

      for (gameweek in Iter.fromList(currentSeason.gameweeks)) {
        if (List.size(gameweek.fixtures) > 0) {
          return #err(#InvalidData);
        };
      };

      //there are 380 fixtures
      if (Array.size(seasonFixtures) != 380) {
        return #err(#InvalidData);
      };

      let teams = await getTeams();
      let teamIds = Array.map<T.Team, T.TeamId>(teams, func(t : T.Team) : T.TeamId { return t.id });

      let uniqueTeamIdsBuffer = Buffer.fromArray<T.TeamId>([]);

      for (teamId in Iter.fromArray(teamIds)) {
        if (not Buffer.contains<T.TeamId>(uniqueTeamIdsBuffer, teamId, func(a : T.TeamId, b : T.TeamId) : Bool { a == b })) {
          uniqueTeamIdsBuffer.add(teamId);
        };
      };

      //there are 20 teams
      let uniqueTeamIds = Buffer.toArray<T.TeamId>(uniqueTeamIdsBuffer);
      if (Array.size(uniqueTeamIds) != 20) {
        return #err(#InvalidData);
      };

      //19 home games and 19 away games for each team
      let homeGamesCount = Array.tabulate<Nat>(Array.size(uniqueTeamIds), func(_ : Nat) { return 0 });
      let awayGamesCount = Array.tabulate<Nat>(Array.size(uniqueTeamIds), func(_ : Nat) { return 0 });

      let homeGamesBuffer = Buffer.fromArray<Nat>(homeGamesCount);
      let awayGamesBuffer = Buffer.fromArray<Nat>(awayGamesCount);

      for (f in Iter.fromArray(seasonFixtures)) {

        //all default values are set correctly for starting fixture, scores and statuses etc
        if (
          f.homeGoals != 0 or f.awayGoals != 0 or f.status != 0 or not List.isNil(f.events) or f.highestScoringPlayerId != 0,
        ) {
          return #err(#InvalidData);
        };

        //all team ids exist
        let homeTeam = Array.find<T.TeamId>(teamIds, func(teamId : T.TeamId) : Bool { return teamId == f.homeTeamId });
        let awayTeam = Array.find<T.TeamId>(teamIds, func(teamId : T.TeamId) : Bool { return teamId == f.awayTeamId });
        if (homeTeam == null or awayTeam == null) {
          return #err(#InvalidData);
        };

        let homeTeamIndexOpt = findIndex(uniqueTeamIds, f.homeTeamId);
        let awayTeamIndexOpt = findIndex(uniqueTeamIds, f.awayTeamId);

        label check switch (homeTeamIndexOpt, awayTeamIndexOpt) {
          case (?(homeTeamIndex), ?(awayTeamIndex)) {
            let currentHomeGames = homeGamesBuffer.get(homeTeamIndex);
            let currentAwayGames = awayGamesBuffer.get(awayTeamIndex);
            homeGamesBuffer.put(homeTeamIndex, currentHomeGames + 1);
            awayGamesBuffer.put(awayTeamIndex, currentAwayGames + 1);
            break check;
          };
          case _ {
            return #err(#InvalidData);
          };
        };

      };

      let gameweekFixturesBuffer = Buffer.fromArray<Nat>(Array.tabulate<Nat>(38, func(_ : Nat) { return 0 }));

      for (f in Iter.fromArray(seasonFixtures)) {
        let gameweekIndex = f.gameweek - 1;
        let currentCount = gameweekFixturesBuffer.get(Nat8.toNat(gameweekIndex));
        gameweekFixturesBuffer.put(Nat8.toNat(gameweekIndex), currentCount + 1);
      };

      for (i in Iter.fromArray(Buffer.toArray(gameweekFixturesBuffer))) {
        if (gameweekFixturesBuffer.get(i) != 10) {
          return #err(#InvalidData);
        };
      };

      for (i in Iter.fromArray(Buffer.toArray(homeGamesBuffer))) {
        if (homeGamesBuffer.get(i) != 19 or awayGamesBuffer.get(i) != 19) {
          return #err(#InvalidData);
        };
      };

      */
      return #ok();
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
      /*
seasons := List.map<T.Season, T.Season>(
        seasons,
        func(currentSeason : T.Season) : T.Season {
          if (currentSeason.id == seasonId) {

            var seasonGameweeks = List.nil<T.Gameweek>();

            for (i in Iter.range(1, 38)) {
              let fixturesForCurrentGameweek = Array.filter<T.Fixture>(
                fixtures,
                func(fixture : T.Fixture) : Bool {
                  return Nat8.fromNat(i) == fixture.gameweek;
                },
              );

              let newGameweek : T.Gameweek = {
                id = i;
                number = Nat8.fromNat(i);
                canisterId = "";
                fixtures = List.fromArray(fixturesForCurrentGameweek);
              };

              seasonGameweeks := List.push(newGameweek, seasonGameweeks);
            };

            return {
              id = currentSeason.id;
              name = currentSeason.name;
              year = currentSeason.year;
              gameweeks = seasonGameweeks;
              postponedFixtures = currentSeason.postponedFixtures;
            };
          } else { return currentSeason };
        },
      );













      await seasonManager.addInitialFixtures(seasonId, seasonFixtures);
      */
      return #ok();
    };

    public func validateRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      /*
      if (updatedFixtureDate <= Time.now()) {
        return #err(#InvalidData);
      };

      if (updatedFixtureGameweek <= seasonManager.getActiveGameweek()) {
        return #err(#InvalidData);
      };

      let fixture = await seasonManager.getFixture(seasonManager.getActiveSeason().id, currentFixtureGameweek, fixtureId);
      if (fixture.id == 0 or fixture.status == 3) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      //await seasonManager.rescheduleFixture(fixtureId, currentFixtureGameweek, updatedFixtureGameweek, updatedFixtureDate);
      return #ok();
    };

    public func validateLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      /*
      if (loanEndDate <= Time.now()) {
        return #err(#InvalidData);
      };

      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      //player is not already on loan
      if (player.onLoan) {
        return #err(#InvalidData);
      };

      //loan team exists unless 0
      if (loanTeamId > 0) {
        switch (teamsInstance.getTeam(loanTeamId)) {
          case (null) {
            return #err(#InvalidData);
          };
          case (?foundTeam) {};
        };
      };
      */
      return #ok();
    };

    public func executeLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      //await playerCanister.loanPlayer(playerId, loanTeamId, loanEndDate, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
      return #ok();
    };

    public func validateTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      /*
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      //new club is premier league team
      if (newTeamId > 0) {
        switch (teamsInstance.getTeam(newTeamId)) {
          case (null) {
            return #err(#InvalidData);
          };
          case (?foundTeam) {};
        };
      };
      */
      return #ok();
    };

    public func executeTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      //await playerCanister.transferPlayer(playerId, newTeamId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
      return #ok();
    };

    public func validateRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      /*
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      //player is on loan
      if (not player.onLoan) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executeRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      //await playerCanister.recallPlayer(playerId);
      return #ok();
    };

    public func validateCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      /*
      switch (teamsInstance.getTeam(teamId)) {
        case (null) {
          return #err(#InvalidData);
        };
        case (?foundTeam) {};
      };

      if (Text.size(firstName) > 50) {
        return #err(#InvalidData);
      };

      if (Text.size(lastName) > 50) {
        return #err(#InvalidData);
      };

      if (position > 3) {
        return #err(#InvalidData);
      };

      if (not countriesInstance.isCountryValid(nationality)) {
        return #err(#InvalidData);
      };

      if (Utilities.calculateAgeFromUnix(dateOfBirth) < 16) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executeCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      //await playerCanister.createPlayer(teamId, position, firstName, lastName, shirtNumber, value, dateOfBirth, nationality);
      return #ok();
    };

    public func validateUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      /*
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      if (Text.size(firstName) > 50) {
        return #err(#InvalidData);
      };

      if (Text.size(lastName) > 50) {
        return #err(#InvalidData);
      };

      if (position > 3) {
        return #err(#InvalidData);
      };

      if (not countriesInstance.isCountryValid(nationality)) {
        return #err(#InvalidData);
      };

      if (Utilities.calculateAgeFromUnix(dateOfBirth) < 16) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executeUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
     //await playerCanister.updatePlayer(playerId, position, firstName, lastName, shirtNumber, dateOfBirth, nationality);
      return #ok();
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      /*
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0 or player.isInjured) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
       //await playerCanister.setPlayerInjury(playerId, description, expectedEndDate);
      return #ok();
    };
    
    public func validateRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      /*
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0 or player.retirementDate > 0) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executeRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
     //await playerCanister.retirePlayer(playerId, retirementDate);
      return #ok();
    };

    public func validateUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      /*
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0 or player.retirementDate == 0) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };
    
    public func executeUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      //await playerCanister.unretirePlayer(playerId);
      return #ok();
    };

    public func validatePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      /*
      let allTeams = teamsInstance.getTeams();

      if (Array.size(allTeams) >= 20) {
        return #err(#InvalidData);
      };

      let activeSeason = seasonManager.getActiveSeason();
      let seasonFixtures = seasonManager.getFixturesForSeason(activeSeason.id);
      if (Array.size(seasonFixtures) > 0) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      //await teamsInstance.promoteFormerTeam(teamId);
      return #ok();
    };

    public func validatePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      /*
      let allTeams = teamsInstance.getTeams();

      if (Array.size(allTeams) >= 20) {
        return #err(#InvalidData);
      };

      let activeSeason = seasonManager.getActiveSeason();
      let seasonFixtures = seasonManager.getFixturesForSeason(activeSeason.id);
      if (Array.size(seasonFixtures) > 0) {
        return #err(#InvalidData);
      };

      if (Text.size(name) > 100) {
        return #err(#InvalidData);
      };

      if (Text.size(friendlyName) > 50) {
        return #err(#InvalidData);
      };

      if (Text.size(abbreviatedName) != 3) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(primaryHexColour)) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(secondaryHexColour)) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(thirdHexColour)) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
     //await teamsInstance.promoteNewTeam(name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour, shirtType);
      return #ok();
    };

    public func validateUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      /*
      switch (teamsInstance.getTeam(teamId)) {
        case (null) {
          return #err(#InvalidData);
        };
        case (?foundTeam) {};
      };

      if (Text.size(name) > 100) {
        return #err(#InvalidData);
      };

      if (Text.size(friendlyName) > 50) {
        return #err(#InvalidData);
      };

      if (Text.size(abbreviatedName) != 3) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(primaryHexColour)) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(secondaryHexColour)) {
        return #err(#InvalidData);
      };

      if (not Utilities.validateHexColor(thirdHexColour)) {
        return #err(#InvalidData);
      };
      */
      return #ok();
    };

    public func executeUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
     //await teamsInstance.updateTeam(teamId, name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour, shirtType);
      return #ok();
    };


  };
};
