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
import Blob "mo:base/Blob";
import SnapshotManager "patterns/snapshot-manager";
import SnapshotFactory "patterns/snapshot-factory";
import PlayerComposite "patterns/player-composite";
import ClubComposite "patterns/club-composite";
import StrategyManager "patterns/strategy-manager";
import ManagerProfileManager "patterns/manager-profile-manager";
import Utilities "utilities";

module {

  public class SeasonManager(setAndBackupTimer : (duration : Timer.Duration, timerInfo: T.TimerInfo) -> async ()) {

    let strategyManager = StrategyManager.StrategyManager();
    let managerProfileManager = ManagerProfileManager.ManagerProfileManager();
    
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

    public func gameweekBegin() : async () {
      snapshotManager.snapshotFantasyTeams();
      managerProfileManager.resetFantasyTeams();  
    };

    
    public func gameKickOff() : async () {
      updateFixtureStatuses();
      setGameCompletedTimers(); //Look for any active game and set completed 2 hours from kickoff
      await updateCacheHash("fixtures");
    };

    
    public func gameCompleted() : async () {
      updateFixtureStatuses(); //update any active game that is 2 hours after it's kickoff to completed
      await updateCacheHash("fixtures");        
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
    

    public func getSystemState() : DTOs.SystemStateDTO {
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
    
    public func getProfile(principalId: Text) : async Result.Result<DTOs.ProfileDTO, T.Error> {
      let manager = managers.get(principalId);
      return await managerProfileManager.getProfile(manager);
    };
    
    /* Will need when profile DTO isn't enough
    public func getManager(principalId: Text){
      
    };
    */
    
    public func getTotalManagers() : Nat{
      let managersWithTeams = Iter.filter<T.Manager>(managers.vals(), func (manager : T.Manager) : Bool { Array.size(manager.playerIds) == 11 });
      return Iter.size(managersWithTeams);
    };

    public func createProfile(principalId: Text, createProfileDTO: DTOs.ProfileDTO) : async Result.Result<(), T.Error> {
      
      var profilePictureCanisterId = "";
      if(createProfileDTO.profilePicture.size() > 0){
        profilePictureCanisterId := managerProfileManager.updateProfilePicture(principalId, createProfileDTO.profilePicture);
      };

      let newManager = managerProfileManager.buildNewManager(principalId, createProfileDTO, profilePictureCanisterId);
      managers.put(principalId, newManager);
      return #ok();
    };

    public func saveFantasyTeam(principalId: Text, updatedFantasyTeam: DTOs.UpdateFantasyTeamDTO) : async Result.Result<(), T.Error>{
      
      if(not strategyManager.isFantasyTeamValid(updatedFantasyTeam)){
        return #err(#InvalidTeamError);
      };

      let updatedManager = managerProfileManager.updateManager(principalId, managers.get(principalId), updatedFantasyTeam);
      managers.put(principalId, updatedManager);

      return #ok();
    };

    public func updateUsername(principalId: Text, updatedUsername: Text) : async Result.Result<(), T.Error>{
      
      if(not managerProfileManager.isUsernameValid(updatedUsername)){
        return #err(#InvalidData);
      };

      if(not managerProfileManager.isUsernameAvailable(updatedUsername)){
        return #err(#NotAllowed);
      };

      let updatedManager = managerProfileManager.updateUsername(principalId, managers.get(principalId), updatedUsername);
      switch(updatedManager){
        case (null){
          return #err(#NotFound);
        };
        case(?foundUpdatedManager){
          managers.put(principalId, foundUpdatedManager);
          return #ok();
        };
      }
    };
    
    public func isUsernameAvailable(username: Text) : Bool{
      return managerProfileManager.isUsernameAvailable(username);
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
