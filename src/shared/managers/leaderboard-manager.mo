
import Result "mo:base/Result";
import List "mo:base/List";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import DTOs "../../shared/DTOs";
import T "../../shared/types";
import Utilities "../../shared/utils/utilities";
import Management "../../shared/utils/Management";
import NetworkEnvVars "../network_environment_variables";
import WeeklyLeaderboardCanister "../canister_definitions/weekly-leaderboard";
import MonthlyLeaderboardsCanister "../canister_definitions/monthly-leaderboards";
import SeasonLeaderboardCanister "../canister_definitions/season-leaderboard";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import RewardManager "reward-manager";

module {

  public class LeaderboardManager(controllerPrincipalId: Text, seasonGameweekCount: Nat8, seasonMonthCount: Nat8) {
   
    private var weeklyLeaderboardCanisters : List.List<T.WeeklyLeaderboardCanister> = List.nil();
    private var monthlyLeaderboardsCanisters : List.List<T.MonthlyLeaderboardsCanister> = List.nil();
    private var seasonLeaderboardCanisters : List.List<T.SeasonLeaderboardCanister> = List.nil();
    private var backendCanisterController : ?Principal = null;//TODO NOW Set on load
    private var storeCanisterId : ?((canisterId : Text) -> async ()) = null;//TODO NOW Set on load

    private let rewardManager = RewardManager.RewardManager(seasonGameweekCount, seasonMonthCount);
    
    public func setStoreCanisterIdFunction(
      _storeCanisterId : (canisterId : Text) -> async (),
    ) {
      storeCanisterId := ?_storeCanisterId;
    }; //TODO LATER: Ensure called


    public func setBackendCanisterController(controller : Principal) {
      backendCanisterController := ?controller;
    }; //TODO LATER: Ensure called  

    public func getWeeklyCanisterId(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async ?Text {
      let leaderboardCanisterId = List.find<T.WeeklyLeaderboardCanister>(
        weeklyLeaderboardCanisters,
        func(canister : T.WeeklyLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId and canister.gameweek == gameweek;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) { return null };
        case (?foundCanister) {
          return ?foundCanister.canisterId;
        };
      };
    };

    public func getMonthlyCanisterId(seasonId : T.SeasonId, month : T.CalendarMonth) : async ?Text {
      let leaderboardCanisterId = List.find<T.MonthlyLeaderboardsCanister>(
        monthlyLeaderboardsCanisters,
        func(canister : T.MonthlyLeaderboardsCanister) : Bool {
          return canister.seasonId == seasonId and canister.month == month
        },
      );

      switch (leaderboardCanisterId) {
        case (null) { return null };
        case (?foundCanister) {
          return ?foundCanister.canisterId;
        };
      };
    };

    public func getSeasonCanisterId(seasonId : T.SeasonId) : async ?Text {
      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        seasonLeaderboardCanisters,
        func(canister : T.SeasonLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) { return null };
        case (?foundCanister) {
          return ?foundCanister.canisterId;
        };
      };
    };

    public func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.WeeklyLeaderboardCanister>(
        weeklyLeaderboardCanisters,
        func(canister : T.WeeklyLeaderboardCanister) : Bool {
          return canister.seasonId == dto.seasonId and canister.gameweek == dto.gameweek;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let weekly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.WeeklyLeaderboardDTO;
          };

          let leaderboardEntries = await weekly_leaderboard_canister.getEntries(dto, dto.searchTerm);
          switch (leaderboardEntries) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundLeaderboard) {
              return #ok(foundLeaderboard);
            };
          };
        };
      };
    };

    public func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {

      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardsCanisterId = List.find<T.MonthlyLeaderboardsCanister>(
        monthlyLeaderboardsCanisters,
        func(canister : T.MonthlyLeaderboardsCanister) : Bool {
          return canister.seasonId == dto.seasonId and canister.month == dto.month 
        },
      );

      switch (leaderboardsCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, clubId: T.ClubId, searchTerm : Text) -> async ?DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries(dto, dto.clubId, dto.searchTerm);
          switch (leaderboardEntries) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundLeaderboard) {
              return #ok(foundLeaderboard);
            };
          };
        };
      };
    };

    public func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {

      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        seasonLeaderboardCanisters,
        func(canister : T.SeasonLeaderboardCanister) : Bool {
          return canister.seasonId == dto.seasonId ;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          let season_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntries : (filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.SeasonLeaderboardDTO;
          };

          let leaderboardEntries = await season_leaderboard_canister.getEntries(dto, dto.searchTerm);
          switch (leaderboardEntries) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundLeaderboard) {
              return #ok(foundLeaderboard);
            };
          };
        };
      };
    };

    public func getWeeklyLeaderboardEntry(principalId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanisterId = List.find<T.WeeklyLeaderboardCanister>(
        weeklyLeaderboardCanisters,
        func(canister : T.WeeklyLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId and canister.gameweek == gameweek;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          let weekly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntry : (principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await weekly_leaderboard_canister.getEntry(principalId);
          return leaderboardEntry;
        };
      };
    };

    public func getMonthlyLeaderboardEntry(principalId : Text, seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanisterId = List.find<T.MonthlyLeaderboardsCanister>(
        monthlyLeaderboardsCanisters,
        func(canister : T.MonthlyLeaderboardsCanister) : Bool {
          return canister.seasonId == seasonId and canister.month == month
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          let monthly_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntry : (principalId : Text, clubid: T.ClubId) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await monthly_leaderboard_canister.getEntry(principalId, clubId);
          return leaderboardEntry;
        };
      };
    };

    public func getSeasonLeaderboardEntry(principalId : Text, seasonId : T.SeasonId) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanisterId = List.find<T.SeasonLeaderboardCanister>(
        seasonLeaderboardCanisters,
        func(canister : T.SeasonLeaderboardCanister) : Bool {
          return canister.seasonId == seasonId;
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          let season_leaderboard_canister = actor (foundCanister.canisterId) : actor {
            getEntry : (principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await season_leaderboard_canister.getEntry(principalId);
          return leaderboardEntry;
        };
      };
    };

    public func calculateLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, uniqueManagerCanisterIds : [T.CanisterId]) : async () {
      
      let weeklyLeaderboardCanister = List.find<T.WeeklyLeaderboardCanister>(weeklyLeaderboardCanisters, 
        func (canister: T.WeeklyLeaderboardCanister) : Bool{
          return canister.seasonId == seasonId and canister.gameweek == gameweek; 
        }
      );

      let monthlyLeaderboardCanister = List.find<T.MonthlyLeaderboardsCanister>(monthlyLeaderboardsCanisters, 
        func (canister: T.MonthlyLeaderboardsCanister) : Bool{
          return canister.seasonId == seasonId and canister.month == month; 
        }
      );

      let seasonLeaderboardCanister = List.find<T.SeasonLeaderboardCanister>(seasonLeaderboardCanisters, 
        func (canister: T.SeasonLeaderboardCanister) : Bool{
          return canister.seasonId == seasonId; 
        }
      );

      var weeklyLeaderboardCanisterId = "";
      var monthlyLeaderboardCanisterId = "";
      var seasonLeaderboardCanisterId = "";

      switch(weeklyLeaderboardCanister){
        case (null){
          weeklyLeaderboardCanisterId := await createWeeklyLeaderboardCanister(seasonId, gameweek);
        };
        case (?foundCanisterInfo){
          weeklyLeaderboardCanisterId := foundCanisterInfo.canisterId;
        };
      };

      switch(monthlyLeaderboardCanister){
        case (null){
          monthlyLeaderboardCanisterId := await createMonthlyLeaderboardsCanister(seasonId, month);
        };
        case (?foundCanisterInfo){
          monthlyLeaderboardCanisterId := foundCanisterInfo.canisterId;
        };
      };

      switch(seasonLeaderboardCanister){
        case (null){
          seasonLeaderboardCanisterId := await createSeasonLeaderboardCanister(seasonId);
        };
        case (?foundCanisterInfo){
          seasonLeaderboardCanisterId := foundCanisterInfo.canisterId;
        };
      };

      let weekly_leaderboard_canister = actor (weeklyLeaderboardCanisterId) : actor {
        addLeaderboardChunk : (entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : () -> async ();
        finaliseUpdate : () -> async ();
      };

      let monthly_leaderboard_canister = actor (monthlyLeaderboardCanisterId) : actor {
        addLeaderboardChunk : (clubId: T.ClubId, entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : () -> async ();
        finaliseUpdate : () -> async ();
      };

      let season_leaderboard_canister = actor (seasonLeaderboardCanisterId) : actor {
        addLeaderboardChunk : (entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : () -> async ();
        finaliseUpdate : () -> async ();
      };

      await weekly_leaderboard_canister.prepareForUpdate();
      await monthly_leaderboard_canister.prepareForUpdate();
      await season_leaderboard_canister.prepareForUpdate();

      for (canisterId in Iter.fromArray(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getOrderedSnapshots : (seasonId : T.SeasonId, gameweek : T.GameweekNumber) -> async [T.FantasyTeamSnapshot];
        };

        let orderedSnapshots = await manager_canister.getOrderedSnapshots(seasonId, gameweek);
        
        let groupedByTeam = groupByTeam(orderedSnapshots);

        for(team in groupedByTeam.entries(
        )){
          let fantasyTeamSnapshots = team.1;

          let leaderboardEntries = Array.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
          fantasyTeamSnapshots,
            func(snapshot) {
              return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.points);
            },
          );
          await weekly_leaderboard_canister.addLeaderboardChunk(leaderboardEntries);
          await monthly_leaderboard_canister.addLeaderboardChunk(team.0, leaderboardEntries);
          await season_leaderboard_canister.addLeaderboardChunk(leaderboardEntries);
        };
      };

      await weekly_leaderboard_canister.finaliseUpdate();
      await monthly_leaderboard_canister.finaliseUpdate();
      await season_leaderboard_canister.finaliseUpdate();
    };

    private func groupByTeam(snapshots : [T.FantasyTeamSnapshot]) : TrieMap.TrieMap<T.ClubId, [T.FantasyTeamSnapshot]> {
      let groupedTeams : TrieMap.TrieMap<T.ClubId, [T.FantasyTeamSnapshot]> = TrieMap.TrieMap<T.ClubId, [T.FantasyTeamSnapshot]>(Utilities.eqNat16, Utilities.hashNat16);

      for (fantasyTeam in Iter.fromArray(snapshots)) {
        switch(fantasyTeam.favouriteClubId){
          case (?foundClubId){
            switch (groupedTeams.get(foundClubId)) {
              case null {
                groupedTeams.put(foundClubId, [fantasyTeam]);
              };
              case (?existingEntries) {
                let updatedEntries = Buffer.fromArray<T.FantasyTeamSnapshot>(existingEntries);
                updatedEntries.add(fantasyTeam);
                groupedTeams.put(foundClubId, Buffer.toArray(updatedEntries));
              };
            };
          };
          case (null){

          }
        };
      };

      return groupedTeams;
    };

    private func createWeeklyLeaderboardCanister(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async Text {
      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(10_000_000_000_000);
      let canister = await WeeklyLeaderboardCanister._WeeklyLeaderboardCanister(controllerPrincipalId);
      let IC : Management.Management = actor (NetworkEnvVars.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      let weeklyLeaderboardCanisterId = Principal.toText(canister_principal);

      let gameweekCanisterInfo : T.WeeklyLeaderboardCanister = {
        seasonId = seasonId;
        gameweek = gameweek;
        canisterId = weeklyLeaderboardCanisterId;
      };

      weeklyLeaderboardCanisters := List.append(weeklyLeaderboardCanisters, List.fromArray([gameweekCanisterInfo]));

      return weeklyLeaderboardCanisterId;
    };

    private func createMonthlyLeaderboardsCanister(seasonId : T.SeasonId, month : T.CalendarMonth) : async Text {

      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(10_000_000_000_000);
      let canister = await MonthlyLeaderboardsCanister._MonthlyLeaderboardsCanister(controllerPrincipalId);
      let IC : Management.Management = actor (NetworkEnvVars.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      let monthlyLeaderboardsCanisterId = Principal.toText(canister_principal);

      let monthlyCanisterInfo : T.MonthlyLeaderboardsCanister = {
        seasonId = seasonId;
        month = month;
        canisterId = monthlyLeaderboardsCanisterId;
      };

      monthlyLeaderboardsCanisters := List.append(monthlyLeaderboardsCanisters, List.fromArray([monthlyCanisterInfo]));

      return monthlyLeaderboardsCanisterId;
    };

    private func createSeasonLeaderboardCanister(seasonId : T.SeasonId) : async Text {
      if (backendCanisterController == null) {
        return "";
      };

      Cycles.add<system>(10_000_000_000_000);
      let canister = await SeasonLeaderboardCanister._SeasonLeaderboardCanister(controllerPrincipalId);
      let IC : Management.Management = actor (NetworkEnvVars.Default);
      let _ = await Utilities.updateCanister_(canister, backendCanisterController, IC);
      let canister_principal = Principal.fromActor(canister);
      let seasonLeaderboardCanisterId = Principal.toText(canister_principal);

      let seasonCanisterInfo : T.SeasonLeaderboardCanister = {
        seasonId = seasonId;
        canisterId = seasonLeaderboardCanisterId;
      };

      seasonLeaderboardCanisters := List.append(seasonLeaderboardCanisters, List.fromArray([seasonCanisterInfo]));

      return seasonLeaderboardCanisterId;
    };

    private func createLeaderboardEntry(principalId : Text, username : Text, points : Int16) : T.LeaderboardEntry {
      return {
        position = 0;
        positionText = "";
        username = username;
        principalId = principalId;
        points = points;
      };
    }; 

    public func getWeeklyLeaderboardCanisters() : [T.WeeklyLeaderboardCanister] {
        return List.toArray(weeklyLeaderboardCanisters);
    };

    public func getMonthlyLeaderboardsCanisters() : [T.MonthlyLeaderboardsCanister] {
        return List.toArray(monthlyLeaderboardsCanisters);
    };

    public func getSeasonLeaderboardCanisters() : [T.SeasonLeaderboardCanister] {
        return List.toArray(seasonLeaderboardCanisters);
    };

    public func getRewardPool(seasonId: T.SeasonId) : ?T.RewardPool {
        return rewardManager.getRewardPool(seasonId);
    };

    public func payWeeklyRewards() : async () {
      //TODO LATER
      /* Removed inputs but what should be passed
      weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO, filters: DTOs.GameweekFiltersDTO, fixtures : List.List<DTOs.FixtureDTO>, uniqueManagerCanisterIds: List.List<T.CanisterId>
      */
      /* //TODO
      await rewardManager.distributeWeeklyRewards(weeklyLeaderboard);
      await rewardManager.distributeHighestScoringPlayerRewards(filters.seasonId, filters.gameweek, fixtures, uniqueManagerCanisterIds);
      await rewardManager.distributeWeeklyATHScoreRewards(weeklyLeaderboard);
      */
    };

    public func payMonthlyRewards() : async () {
      /* Removed inputs but what should be passed
        seasonId: T.SeasonId, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO], uniqueManagerCanisterIds: List.List<T.CanisterId>
      */
      /*
        await rewardManager.distributeMonthlyRewards(seasonId, monthlyLeaderboards, uniqueManagerCanisterIds);
        await rewardManager.distributeMonthlyATHScoreRewards(seasonId, monthlyLeaderboards);
      */
    };

    public func paySeasonRewards() : async () {
      /* Removed inputs but what should be passed
      seasonLeaderboard : DTOs.SeasonLeaderboardDTO, players : [DTOs.PlayerDTO], seasonId : T.SeasonId, uniqueManagerCanisterIds: List.List<T.CanisterId>
      */
      /*
      await rewardManager.distributeSeasonRewards(seasonLeaderboard);
      await rewardManager.distributeSeasonATHScoreRewards(seasonLeaderboard);
      await rewardManager.distributeMostValuableTeamRewards(players, seasonId, uniqueManagerCanisterIds);
      */
    };

    //TODO NOW: Ensure used

    //Statble Storage 

    public func getStableRewardPools() : [(T.SeasonId, T.RewardPool)]{
      return rewardManager.getStableRewardPools();
    };

    public func getStableMonthlyLeaderboardsCanisters() : [T.MonthlyLeaderboardsCanister] {
      return List.toArray(monthlyLeaderboardsCanisters);
    };

    public func getStableSeasonLeaderboardCanisters() : [T.SeasonLeaderboardCanister] {
      return List.toArray(seasonLeaderboardCanisters);
    };

    public func setStableSeasonLeaderboardCanisters(stable_season_leaderboard_canisters : [T.SeasonLeaderboardCanister]) {
      seasonLeaderboardCanisters := List.fromArray(stable_season_leaderboard_canisters);
    };

    public func setStableMonthlyLeaderboardsCanisters(stable_monthly_leaderboards_canisters : [T.MonthlyLeaderboardsCanister]) {
      monthlyLeaderboardsCanisters := List.fromArray(stable_monthly_leaderboards_canisters);
    };

    public func getStableWeeklyLeaderboardCanisters() : [T.WeeklyLeaderboardCanister] {
      return List.toArray(weeklyLeaderboardCanisters);
    };

    public func getStableWeeklyAllTimeHighScores() : [T.HighScoreRecord] {
      return rewardManager.getStableWeeklyAllTimeHighScores();
    };

    public func getStableMonthlyAllTimeHighScores() : [T.HighScoreRecord] {
      return rewardManager.getStableMonthlyAllTimeHighScores();
    };

    public func getStableSeasonAllTimeHighScores() : [T.HighScoreRecord] {
      return rewardManager.getStableSeasonAllTimeHighScores();
    };

    public func setStableRewardPools(stable_reward_pools: [(T.SeasonId, T.RewardPool)]){
      rewardManager.setStableRewardPools(stable_reward_pools);
    };

    public func setStableWeeklyLeaderboardCanisters(stable_weekly_leaderboard_canisters : [T.WeeklyLeaderboardCanister]) {
      weeklyLeaderboardCanisters := List.fromArray(stable_weekly_leaderboard_canisters);
    };

    public func getStableTeamValueLeaderboards() : [(T.SeasonId, T.TeamValueLeaderboard)] {
      return rewardManager.getStableTeamValueLeaderboards();
    };

    public func setStableTeamValueLeaderboards(stable_team_value_leaderboards : [(T.SeasonId, T.TeamValueLeaderboard)]) {
      return rewardManager.setStableTeamValueLeaderboards(stable_team_value_leaderboards);
    };

    public func getStableSeasonRewards() : [T.SeasonRewards] {
      return rewardManager.getStableSeasonRewards();
    };

    public func setStableSeasonRewards(stable_season_rewards : [T.SeasonRewards]) {
      return rewardManager.setStableSeasonRewards(stable_season_rewards);
    };

    public func getStableMonthlyRewards() : [T.MonthlyRewards] {
      return rewardManager.getStableMonthlyRewards();
    };

    public func setStableMonthlyRewards(stable_monthly_rewards : [T.MonthlyRewards]) {
      return rewardManager.setStableMonthlyRewards(stable_monthly_rewards);
    };

    public func getStableWeeklyRewards() : [T.WeeklyRewards] {
      return rewardManager.getStableWeeklyRewards();
    };

    public func setStableWeeklyRewards(stable_weekly_rewards : [T.WeeklyRewards]) {
      return rewardManager.setStableWeeklyRewards(stable_weekly_rewards);
    };

    public func getStableMostValuableTeamRewards() : [T.RewardsList] {
      return rewardManager.getStableMostValuableTeamRewards();
    };

    public func setStableMostValuableTeamRewards(stable_most_valuable_team_rewards : [T.RewardsList]) {
      return rewardManager.setStableMostValuableTeamRewards(stable_most_valuable_team_rewards);
    };

    public func getStableHighestScoringPlayerRewards() : [T.RewardsList] {
      return rewardManager.getStableHighestScoringPlayerRewards();
    };

    public func setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards : [T.RewardsList]) {
      return rewardManager.setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards);
    };

    public func setStableWeeklyAllTimeHighScores(stable_weekly_all_time_high_scores: [T.HighScoreRecord]) {
      return rewardManager.setStableWeeklyAllTimeHighScores(stable_weekly_all_time_high_scores);
    };

    public func setStableMonthlyAllTimeHighScores(stable_monthly_all_time_high_scores: [T.HighScoreRecord]) {
      return rewardManager.setStableMonthlyAllTimeHighScores(stable_monthly_all_time_high_scores);
    };

    public func setStableSeasonAllTimeHighScores(stable_season_all_time_high_scores: [T.HighScoreRecord]) {
      return rewardManager.setStableSeasonAllTimeHighScores(stable_season_all_time_high_scores);
    };

    public func getStableWeeklyATHPrizePool() : Nat64 {
      return rewardManager.getStableWeeklyATHPrizePool();
    };

    public func setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool : Nat64) {
      return rewardManager.setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool);
    };

    public func getStableMonthlyATHPrizePool() : Nat64 {
      return rewardManager.getStableMonthlyATHPrizePool();
    };

    public func setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool : Nat64) {
      return rewardManager.setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool);
    };

    public func getStableSeasonATHPrizePool() : Nat64 {
      return rewardManager.getStableSeasonATHPrizePool();
    };

    public func setStableSeasonATHPrizePool(stable_season_ath_prize_pool : Nat64) {
      return rewardManager.setStableSeasonATHPrizePool(stable_season_ath_prize_pool);
    };

    //TODO NOW: Add statble storage for reward pools

    
  };

};