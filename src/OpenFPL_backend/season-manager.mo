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

  public class SeasonManager(setAndBackupTimer : (timerInfo: T.TimerInfo) -> async ()) {

    let systemState: T.SystemState = {
      calculationGameweek = 1;
      calculationMonth = 8;
      calculationSeason = 1;
      pickTeamGameweek = 1;
      homepageFixturesGameweek = 1;
      homepageManagerGameweek = 0;
    };

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

    public func gameweekBegin() : async () {
      await snapshotGameweek(systemState.calculationSeason, systemState.calculationGameweek);
      await resetTransfers();

      let gameweekFixtures = seasonsInstance.getGameweekFixtures(systemState.calculationSeason, systemState.calculationGameweek);
      var gameKickOffTimers = List.nil<T.TimerInfo>();
      for (i in Iter.range(0, Array.size(gameweekFixtures) - 1)) {
        let gameKickOffDuration : Timer.Duration = #nanoseconds(Int.abs(gameweekFixtures[i].kickOff - Time.now()));
        switch (setAndBackupTimer) {
          case (null) {};
          case (?actualFunction) {
            await actualFunction(gameKickOffDuration, "gameKickOffExpired", gameweekFixtures[i].id);
          };
        };
      };
    };

    
    public func gameKickOff() : async () {
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
    };

    
    public func gameCompleted() : async () {
      //NEED TO CHECK IF JANUARY 1ST IS IN THE UPCOMING GAMEWEEK THEN SET A TIMER TO BEGIN THE TRANSFER WINDOW IF IT IS
      //NEED TO CHECK IF JANUARY 31ST IS IN THE UPCOMING GAMEWEEK THEN SET A TIMER TO END THE TRANSFER WINDOW IF IT IS

      let activeFixtures = seasonsInstance.getGameweekFixtures(systemState.calculationSeason, systemState.calculationGameweek);
      let timerCreatedTimes = Buffer.fromArray<Int>([]);

      for (i in Iter.range(0, Array.size(activeFixtures) -1)) {
        if ((activeFixtures[i].kickOff + (oneHour * 2)) <= Time.now() and activeFixtures[i].status == 1) {

          let updatedFixture = await seasonsInstance.updateStatus(systemState.calculationSeason, systemState.calculationGameweek, activeFixtures[i].id, 2);

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

    public func loanExpiredCallback() : async () {
      executeRecallPlayer();
    };

    
    public func transferWindowStartCallback() : async () {
      //SETUP THE JAN TRANSFER WINDOW
    };
    
    public func transferWindowEndCallback() : async () {
      //END THE JAN TRANSFER WINDOW
    };
    
    public func getSystemState() : async T.SystemStateDTO {
      return systemState;
    };
    
    public func getDataHashes() : async T.DataCacheDTO {
      return dataCacheDTO;
    };
    
    public func getFixtures(seasonId: T.SeasonId) : async [T.FixtureDTO] {
      return [];
    };
    
    public func getPlayers() : async [T.PlayerDTO] {
      return [];
    };

    public func getDetailedPlayers(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async [T.PlayerDTO] {
      return [];
    };

    public func getWeeklyLeaderboard(seasonId: T.SeasonId, gameweek: T.GameweekNumber) : async DTOs.WeeklyLeaderboardDTO {

    };
    
    public func getClubLeaderboard(seasonId: T.SeasonId, clubId: T.ClubId, month: T.CalendarMonth){

    };
    
    public func getSeasonLeaderboard(seasonId: T.SeasonId){

    };
    
    public func getProfile(principalId: Text){

    };
    
    public func getManager(principalId: Text){

    };
    
    public func getTotalManagers(principalId: Text){

    };
    
    public func isUsernameAvailable(username: Text){

    };
    
    public func createProfile(principalId: Text){
      var existingProfile = profilesInstance.getProfile(Principal.toText(caller));
      switch (existingProfile) {
        case (null) {
          profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
        };
        case (_) {};
      };
    };
    
    public func updateUsername(principalId: Text, username: Text){

      assert not Principal.isAnonymous(caller);
      let invalidName = not profilesInstance.isDisplayNameValid(displayName);
      assert not invalidName;

      var profile = profilesInstance.getProfile(Principal.toText(caller));
      switch (profile) {
        case (null) {
          profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
          profile := profilesInstance.getProfile(Principal.toText(caller));
        };
        case (?foundProfile) {};
      };

      fantasyTeamsInstance.updateDisplayName(Principal.toText(caller), displayName);
      return profilesInstance.updateDisplayName(Principal.toText(caller), displayName);

    };
    
    public func updateFavouriteClub(principalId: Text, favouriteClubId: T.ClubId){


      var profile = profilesInstance.getProfile(Principal.toText(caller));
      switch (profile) {
        case (null) {
          profilesInstance.createProfile(Principal.toText(caller), Principal.toText(caller));
          profile := profilesInstance.getProfile(Principal.toText(caller));
        };
        case (?foundProfile) {
          if (foundProfile.favouriteTeamId > 0) {
            assert not seasonManager.seasonActive();
          };
        };
      };

      fantasyTeamsInstance.updateFavouriteTeam(Principal.toText(caller), favouriteTeamId);
      return profilesInstance.updateFavouriteTeam(Principal.toText(caller), favouriteTeamId);
    };
    
    public func updateProfilePicture(principalId: Text, profilePicture: Blob){

      let sizeInKB = Array.size(Blob.toArray(profilePicture)) / 1024;
      if (sizeInKB > 4000) {
        return #err(#NotAllowed);
      };

      return profilesInstance.updateProfilePicture(Principal.toText(caller), profilePicture);
    };

    public func saveFantasyTeam(principalId: Text, fantasyTeam: DTOs.UpdateFantasyTeamDTO){

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
    };

    public func validateRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : Bool {
      return #ok();
    };

    public func executeRevaluePlayerUp(revaluePlayerUpDTO: DTOs.RevaluePlayerUpDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : Bool {
      return #ok();
    };

    public func executeRevaluePlayerDown(revaluePlayerDownDTO: DTOs.RevaluePlayerDownDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : Bool {
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

      return true;
    };

    public func executeSubmitFixtureData(submitFixtureData: DTOs.SubmitFixtureDataDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
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

      return #ok();
    };

    public func executeAddInitialFixtures(addInitialFixturesDTO: DTOs.AddInitialFixturesDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
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

      return #ok();
    };

    public func executeRescheduleFixture(rescheduleFixtureDTO: DTOs.RescheduleFixtureDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
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

      return #ok();
    };

    public func executeLoanPlayer(loanPlayerDTO: DTOs.LoanPlayerDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
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

      return #ok();
    };

    public func executeTransferPlayer(transferPlayerDTO: DTOs.TransferPlayerDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0) {
        return #err(#InvalidData);
      };

      //player is on loan
      if (not player.onLoan) {
        return #err(#InvalidData);
      };

      return #ok();
    };

    public func executeRecallPlayer(recallPlayerDTO: DTOs.RecallPlayerDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
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

      return #ok();
    };

    public func executeCreatePlayer(createPlayerDTO: DTOs.CreatePlayerDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
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

      return #ok();
    };

    public func executeUpdatePlayer(updatePlayerDTO: DTOs.UpdatePlayerDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0 or player.isInjured) {
        return #err(#InvalidData);
      };
      return #ok();
    };

    public func executeSetPlayerInjury(setPlayerInjuryDTO: DTOs.SetPlayerInjuryDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };
    
    public func validateRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0 or player.retirementDate > 0) {
        return #err(#InvalidData);
      };
      return #ok();
    };

    public func executeRetirePlayer(retirePlayerDTO: DTOs.RetirePlayerDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      let player = await playerCanister.getPlayer(playerId);
      if (player.id == 0 or player.retirementDate == 0) {
        return #err(#InvalidData);
      };
      return #ok();
    };
    
    public func executeUnretirePlayer(unretirePlayerDTO: DTOs.UnretirePlayerDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validatePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      let allTeams = teamsInstance.getTeams();

      if (Array.size(allTeams) >= 20) {
        return #err(#InvalidData);
      };

      let activeSeason = seasonManager.getActiveSeason();
      let seasonFixtures = seasonManager.getFixturesForSeason(activeSeason.id);
      if (Array.size(seasonFixtures) > 0) {
        return #err(#InvalidData);
      };

      return #ok();
    };

    public func executePromoteFormerClub(promoteFormerClubDTO: DTOs.PromoteFormerClubDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validatePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
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

      return #ok();
    };

    public func executePromoteNewClub(promoteNewClubDTO: DTOs.PromoteNewClubDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };

    public func validateUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
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

      return #ok();
    };

    public func executeUpdateClub(updateClubDTO: DTOs.UpdateClubDTO) : async Result.Result<(), T.Error> {
      return #ok();
    };






























   //include all profile info for caller
    //include all manager info
    //GetProfile
      //GetGameweekPoints?? - Replace with GetProfile which includes their season history
      //Will include their current team and the pick team should copy from this for the in game session changes
   
    //recreate close gameweek timer to be 1 hour before the first fixture of the gameweek you are picking your team for

    //recreate the jan transfer window timer to the next January 1st

    //recreate the close jan transfer window timer for midnight on the 31st Jan

    //recreate timers for active games that are counting down to move a game from inactive to active or active to completed

  


  //Governance target methods

  public shared func executeRevaluePlayerUp(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    await playerCanister.revaluePlayerUp(playerId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
    return #ok();
  };

  public shared func executeRevaluePlayerDown(seasonId : T.SeasonId, gameweek : T.GameweekNumber, playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    await playerCanister.revaluePlayerDown(playerId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
    return #ok();
  };

  public shared func executeSubmitFixtureData(fixtureId : T.FixtureId, playerEventData : [T.PlayerEventData]) : async Result.Result<(), T.Error> {

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
    };

    let fixtureEvents = Buffer.toArray(allPlayerEventsBuffer);
    await seasonManager.fixtureConsensusReached(fixture.seasonId, fixture.gameweek, fixtureId, fixtureEvents);
    return #ok();
  };

  public shared func executeAddInitialFixtures(seasonId : T.SeasonId, seasonFixtures : [T.Fixture]) : async Result.Result<(), T.Error> {
    await seasonManager.addInitialFixtures(seasonId, seasonFixtures);
    return #ok();
  };

  public shared func executeRescheduleFixture(fixtureId : T.FixtureId, currentFixtureGameweek : T.GameweekNumber, updatedFixtureGameweek : T.GameweekNumber, updatedFixtureDate : Int) : async Result.Result<(), T.Error> {
    await seasonManager.rescheduleFixture(fixtureId, currentFixtureGameweek, updatedFixtureGameweek, updatedFixtureDate);
    return #ok();
  };

  public shared func executeTransferPlayer(playerId : T.PlayerId, newTeamId : T.TeamId) : async Result.Result<(), T.Error> {
    await playerCanister.transferPlayer(playerId, newTeamId, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
    return #ok();
  };

  public shared func executeLoanPlayer(playerId : T.PlayerId, loanTeamId : T.TeamId, loanEndDate : Int) : async Result.Result<(), T.Error> {
    await playerCanister.loanPlayer(playerId, loanTeamId, loanEndDate, seasonManager.getActiveSeason().id, seasonManager.getActiveGameweek());
    return #ok();
  };

  public shared func executeRecallPlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    await playerCanister.recallPlayer(playerId);
    return #ok();
  };

  public shared func executeCreatePlayer(teamId : T.TeamId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, value : Nat, dateOfBirth : Int, nationality : T.CountryId) : async Result.Result<(), T.Error> {
    await playerCanister.createPlayer(teamId, position, firstName, lastName, shirtNumber, value, dateOfBirth, nationality);
    return #ok();
  };

  public shared func executeUpdatePlayer(playerId : T.PlayerId, position : Nat8, firstName : Text, lastName : Text, shirtNumber : Nat8, dateOfBirth : Int, nationality : T.CountryId) : async Result.Result<(), T.Error> {
    await playerCanister.updatePlayer(playerId, position, firstName, lastName, shirtNumber, dateOfBirth, nationality);
    return #ok();
  };

  public shared func executeSetPlayerInjury(playerId : T.PlayerId, description : Text, expectedEndDate : Int) : async Result.Result<(), T.Error> {
    await playerCanister.setPlayerInjury(playerId, description, expectedEndDate);
    return #ok();
  };

  public shared func executeRetirePlayer(playerId : T.PlayerId, retirementDate : Int) : async Result.Result<(), T.Error> {
    await playerCanister.retirePlayer(playerId, retirementDate);
    return #ok();
  };

  public shared func executeUnretirePlayer(playerId : T.PlayerId) : async Result.Result<(), T.Error> {
    await playerCanister.unretirePlayer(playerId);
    return #ok();
  };

  public shared func executePromoteFormerTeam(teamId : T.TeamId) : async Result.Result<(), T.Error> {
    await teamsInstance.promoteFormerTeam(teamId);
    return #ok();
  };

  public shared func executePromoteNewTeam(name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text, shirtType : Nat8) : async Result.Result<(), T.Error> {
    await teamsInstance.promoteNewTeam(name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour, shirtType);
    return #ok();
  };

  public shared func executeUpdateTeam(teamId : T.TeamId, name : Text, friendlyName : Text, abbreviatedName : Text, primaryHexColour : Text, secondaryHexColour : Text, thirdHexColour : Text, shirtType : Nat8) : async Result.Result<(), T.Error> {
    await teamsInstance.updateTeam(teamId, name, friendlyName, abbreviatedName, primaryHexColour, secondaryHexColour, thirdHexColour, shirtType);
    return #ok();
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
