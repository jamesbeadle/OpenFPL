
import Result "mo:base/Result";
import List "mo:base/List";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import DTOs "../../shared/DTOs";
import T "../../shared/types";
import Utilities "../../shared/utils/utilities";
import Management "../../shared/utils/Management";
import NetworkEnvVars "../network_environment_variables";
import LeaderboardCanister "../canister_definitions/leaderboard-canister";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import RewardManager "reward-manager";

module {

  public class LeaderboardManager(controllerPrincipalId: Text, seasonGameweekCount: Nat8, seasonMonthCount: Nat8) {
   
    private var leaderboardCanisters : List.List<T.LeaderboardCanister> = List.nil();
    private let rewardManager = RewardManager.RewardManager(seasonGameweekCount, seasonMonthCount);
    private var activeCanisterId = "";
    private var MAX_LEADERBOARDS_PER_CANISTER = 500;

    public func getWeeklyCanisterId(seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async ?Text {
      let leaderboardCanisterInfo = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Weekly weeklyCanister){
              return weeklyCanister.seasonId == seasonId and weeklyCanister.gameweek == gameweek;
            };
            case _ { return false; }
          };
        },
      );

      switch (leaderboardCanisterInfo) {
        case (null) { return null };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Weekly weeklyCanister){
              return ?weeklyCanister.canisterId;
            };
            case _ {
              return null;
            }
          };
        };
      };
    };

    public func getMonthlyCanisterId(seasonId : T.SeasonId, month : T.CalendarMonth, clubId: T.ClubId) : async ?Text {
      let leaderboardCanisterInfo = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Monthly monthlyCanister){
              return monthlyCanister.seasonId == seasonId and monthlyCanister.month == month and monthlyCanister.clubId == clubId;
            };
            case _ { return false; }
          };
        },
      );

      switch (leaderboardCanisterInfo) {
        case (null) { return null };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Weekly weeklyCanister){
              return ?weeklyCanister.canisterId;
            };
            case _ {
              return null;
            }
          };
        };
      };
    };

    public func getSeasonCanisterId(seasonId : T.SeasonId) : async ?Text {
      let leaderboardCanisterInfo = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Season seasonCanister){
              return seasonCanister.seasonId == seasonId;
            };
            case _ { return false; }
          };
        },
      );

      switch (leaderboardCanisterInfo) {
        case (null) { return null };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Season seasonCanister){
              return ?seasonCanister.canisterId;
            };
            case _ {
              return null;
            }
          };
        };
      };
    };

    public func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Weekly leaderboard){
              return leaderboard.seasonId == dto.seasonId and leaderboard.gameweek == dto.gameweek;
            };
            case (_){
              return false;
            }
          };
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Weekly leaderboard){

              let weekly_leaderboard_canister = actor (leaderboard.canisterId) : actor {
                getWeeklyLeaderboardEntries : (seasonId: T.SeasonId, gameweek: T.GameweekNumber, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.WeeklyLeaderboardDTO;
              };

              let leaderboardEntries = await weekly_leaderboard_canister.getWeeklyLeaderboardEntries(leaderboard.seasonId, leaderboard.gameweek, dto, dto.searchTerm);
              switch (leaderboardEntries) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundLeaderboard) {
                  return #ok(foundLeaderboard);
                };
              };
            };
            case (_){
              return #err(#NotFound);
            }
          };
        };
      };
    };

    public func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {

      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Monthly leaderboard){
              return leaderboard.seasonId == dto.seasonId and leaderboard.month == dto.month and leaderboard.clubId == dto.clubId;
            };
            case (_){
              return false;
            }
          };
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Monthly leaderboard){

              let monthly_leaderboard_canister = actor (leaderboard.canisterId) : actor {
                getMonthlyLeaderboardEntries : (seasonId: T.SeasonId, month: T.CalendarMonth, clubId: T.ClubId, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.MonthlyLeaderboardDTO;
              };

              let leaderboardEntries = await monthly_leaderboard_canister.getMonthlyLeaderboardEntries(leaderboard.seasonId, leaderboard.month, leaderboard.clubId, dto, dto.searchTerm);
              switch (leaderboardEntries) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundLeaderboard) {
                  return #ok(foundLeaderboard);
                };
              };
            };
            case (_){
              return #err(#NotFound);
            }
          };
        };
      };
    };

    public func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let leaderboardCanisterId = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Season leaderboard){
              return leaderboard.seasonId == dto.seasonId;
            };
            case (_){
              return false;
            }
          };
        },
      );

      switch (leaderboardCanisterId) {
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Season leaderboard){

              let season_leaderboard_canister = actor (leaderboard.canisterId) : actor {
                getSeasonLeaderboardEntries : (seasonId: T.SeasonId, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.SeasonLeaderboardDTO;
              };

              let leaderboardEntries = await season_leaderboard_canister.getSeasonLeaderboardEntries(leaderboard.seasonId, dto, dto.searchTerm);
              switch (leaderboardEntries) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundLeaderboard) {
                  return #ok(foundLeaderboard);
                };
              };
            };
            case (_){
              return #err(#NotFound);
            }
          };
        };
      };
    };

    public func getWeeklyLeaderboardEntry(principalId : Text, seasonId : T.SeasonId, gameweek : T.GameweekNumber) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanister = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Weekly leaderboard){
              return leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek;
            };
            case (_){
              return false;
            }
          };
        },
      );

      switch (leaderboardCanister) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Weekly leaderboard){
              let weekly_leaderboard_canister = actor (leaderboard.canisterId) : actor {
                getWeeklyLeaderboardEntry : (seasonId: T.SeasonId, gameweek: T.GameweekNumber, principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
              };

              let leaderboardEntry = await weekly_leaderboard_canister.getWeeklyLeaderboardEntry(seasonId, gameweek, principalId);
              return leaderboardEntry;
            };
            case (_){
              return null;
            }
          };
        };
      };
    };

    public func getMonthlyLeaderboardEntry(principalId : Text, seasonId : T.SeasonId, month : T.CalendarMonth, clubId : T.ClubId) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanister = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Monthly leaderboard){
              return leaderboard.seasonId == seasonId and leaderboard.month == month and leaderboard.clubId == clubId;
            };
            case (_){
              return false;
            }
          };
        },
      );

      switch (leaderboardCanister) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Monthly leaderboard){
              let monthly_leaderboard_canister = actor (leaderboard.canisterId) : actor {
                getMonthlyLeaderboardEntry : (seasonId: T.SeasonId, month: T.CalendarMonth, clubId: T.ClubId, principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
              };

              let leaderboardEntry = await monthly_leaderboard_canister.getMonthlyLeaderboardEntry(seasonId, month, clubId, principalId);
              return leaderboardEntry;
            };
            case (_){
              return null;
            }
          };
        };
      };
    };

    public func getSeasonLeaderboardEntry(principalId : Text, seasonId : T.SeasonId) : async ?DTOs.LeaderboardEntryDTO {

      let leaderboardCanister = List.find<T.LeaderboardCanister>(
        leaderboardCanisters,
        func(canister : T.LeaderboardCanister) : Bool {
          switch(canister.leaderboardInfo){
            case (#Season leaderboard){
              return leaderboard.seasonId == seasonId;
            };
            case (_){
              return false;
            }
          };
        },
      );

      switch (leaderboardCanister) {
        case (null) {
          return null;
        };
        case (?foundCanister) {
          switch(foundCanister.leaderboardInfo){
            case (#Season leaderboard){
              let season_leaderboard_canister = actor (leaderboard.canisterId) : actor {
                getSeasonLeaderboardEntry : (seasonId: T.SeasonId, principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
              };

              let leaderboardEntry = await season_leaderboard_canister.getSeasonLeaderboardEntry(seasonId, principalId);
              return leaderboardEntry;
            };
            case (_){
              return null;
            }
          };
        };
      };
    };

    public func calculateLeaderboards(seasonId : T.SeasonId, gameweek : T.GameweekNumber, month : T.CalendarMonth, uniqueManagerCanisterIds : [T.CanisterId], clubIds: [T.ClubId]) : async () {
      
      let weeklyLeaderboardCanister = List.find<T.LeaderboardCanister>(leaderboardCanisters, 
        func (canister: T.LeaderboardCanister) : Bool{
          switch(canister.leaderboardInfo){
            case (#Weekly leaderboard){
              return leaderboard.seasonId == seasonId and leaderboard.gameweek == gameweek; 
            };
            case (_){
              return false;
            };
          };
        }
      );

      let monthlyLeaderboardCanisters = List.filter<T.LeaderboardCanister>(leaderboardCanisters, 
        func (canister: T.LeaderboardCanister) : Bool{
          switch(canister.leaderboardInfo){
            case (#Monthly leaderboard){
              return leaderboard.seasonId == seasonId and leaderboard.month == month; 
            };
            case (_){
              return false;
            };
          };
        }
      );

      let seasonLeaderboardCanister = List.find<T.LeaderboardCanister>(leaderboardCanisters, 
        func (canister: T.LeaderboardCanister) : Bool{
          switch(canister.leaderboardInfo){
            case (#Season leaderboard){
              return leaderboard.seasonId == seasonId; 
            };
            case (_){
              return false;
            };
          };
        }
      );

      var leaderboard_canister = actor (activeCanisterId) : actor {
        getTotalLeaderboards : () -> async Nat;
        addLeaderboardChunk : (seasonId: T.SeasonId, month: T.CalendarMonth, gameweek: T.GameweekNumber, clubId: T.ClubId, entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : () -> async ();
        finaliseUpdate : () -> async ();
      };

      let totalLeaderboards = await leaderboard_canister.getTotalLeaderboards();

      if(activeCanisterId == "" or totalLeaderboards >= MAX_LEADERBOARDS_PER_CANISTER){
        activeCanisterId := await createLeaderboardCanister();
      };
      
      leaderboard_canister := actor (activeCanisterId) : actor {
        getTotalLeaderboards : () -> async Nat;
        addLeaderboardChunk : (seasonId: T.SeasonId, month: T.CalendarMonth, gameweek: T.GameweekNumber, clubId: T.ClubId, entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : () -> async ();
        finaliseUpdate : () -> async ();
      };

      await leaderboard_canister.prepareForUpdate();

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
          await leaderboard_canister.addLeaderboardChunk(seasonId, 0, 0, 0, leaderboardEntries);
          await leaderboard_canister.addLeaderboardChunk(seasonId, 0, gameweek, 0, leaderboardEntries);
          for(clubId in Iter.fromArray(clubIds)){
            await leaderboard_canister.addLeaderboardChunk(seasonId, month, 0, clubId, leaderboardEntries);
          };
        };
      };

      await leaderboard_canister.finaliseUpdate();
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

    private func createLeaderboardCanister() : async Text {
      Cycles.add<system>(50_000_000_000_000);
      let canister = await LeaderboardCanister._LeaderboardCanister(controllerPrincipalId);
      let canister_principal = Principal.fromActor(canister);
      let IC : Management.Management = actor (NetworkEnvVars.Default);
      let _ = await Utilities.updateCanister_(canister, ?Principal.fromText(controllerPrincipalId), IC);
      let leaderboardCanisterId = Principal.toText(canister_principal);
      return leaderboardCanisterId;
    };

    private func storeCanisterId(leaderboardType: T.LeaderboardType, leaderboardInfo: T.LeaderboardInfo){

      let gameweekCanisterInfo : T.LeaderboardCanister = {
        leaderboardInfo = leaderboardInfo;
        leaderboardType = leaderboardType;
      };

      leaderboardCanisters := List.append(leaderboardCanisters, List.fromArray([gameweekCanisterInfo]));
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

    public func getLeaderboardCanisters() : [T.LeaderboardCanister] {
        return List.toArray(leaderboardCanisters);
    };

    public func getRewardPool(seasonId: T.SeasonId) : ?T.RewardPool {
        return rewardManager.getRewardPool(seasonId);
    };

    public func payWeeklyRewards() : async () {
      //TODO (Calculation)
      /* Removed inputs but what should be passed
      weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO, filters: DTOs.GameweekFiltersDTO, fixtures : List.List<DTOs.FixtureDTO>, uniqueManagerCanisterIds: List.List<T.CanisterId>
      */
      /* //TODO (Calculation)
      await rewardManager.distributeWeeklyRewards(weeklyLeaderboard);
      await rewardManager.distributeHighestScoringPlayerRewards(filters.seasonId, filters.gameweek, fixtures, uniqueManagerCanisterIds);
      await rewardManager.distributeWeeklyATHScoreRewards(weeklyLeaderboard);
      */
    };

    public func payMonthlyRewards() : async () {
      //TODO (Calculation)
      /* Removed inputs but what should be passed
        seasonId: T.SeasonId, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO], uniqueManagerCanisterIds: List.List<T.CanisterId>
      */
      /*
        await rewardManager.distributeMonthlyRewards(seasonId, monthlyLeaderboards, uniqueManagerCanisterIds);
        await rewardManager.distributeMonthlyATHScoreRewards(seasonId, monthlyLeaderboards);
      */
    };

    public func paySeasonRewards() : async () {
      //TODO (Calculation)
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

    public func getStableLeaderboardsCanisters() : [T.LeaderboardCanister] {
      return List.toArray(leaderboardCanisters);
    };

    public func setStableLeaderboardCanisters(stable_leaderboard_canisters : [T.LeaderboardCanister]) {
      leaderboardCanisters := List.fromArray(stable_leaderboard_canisters);
    };

    public func getStableLeaderboardCanisters() : [T.LeaderboardCanister] {
      return List.toArray(leaderboardCanisters);
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

    public func setStableWeeklyLeaderboardCanisters(stable_leaderboard_canisters : [T.LeaderboardCanister]) {
      leaderboardCanisters := List.fromArray(stable_leaderboard_canisters);
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

    public func getStableActiveCanisterId() : T.CanisterId {
      return activeCanisterId;
    };

    public func setStableActiveCanisterId(stable_active_canister_id: T.CanisterId){
      activeCanisterId := stable_active_canister_id;
    };

    //TODO NOW: Add statble storage for reward pools
    
    
  };

};