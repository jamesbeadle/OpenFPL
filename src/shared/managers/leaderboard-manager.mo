
import Result "mo:base/Result";
import List "mo:base/List";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import DTOs "../../shared/dtos/DTOs";
import Base "../../shared/types/base_types";
import FootballTypes "../../shared/types/football_types";
import T "../../shared/types/app_types";
import Utilities "../../shared/utils/utilities";
import Management "../../shared/utils/Management";
import NetworkEnvVars "../network_environment_variables";
import LeaderboardCanister "../canister_definitions/leaderboard-canister";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import RewardManager "reward-manager";
import NetworkEnvironmentVariables "../network_environment_variables";

module {

  public class LeaderboardManager(controllerPrincipalId: Text, seasonGameweekCount: Nat8, seasonMonthCount: Nat8) {
   
    private var uniqueLeaderboardCanisterIds: [Base.CanisterId] = [];
    private var weeklyLeaderboardCanisters : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])] = [];
    private var monthlyLeaderboardCanisters : [(FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])] = [];
    private var seasonLeaderboardCanisters : [(FootballTypes.SeasonId, Base.CanisterId)] = [];
     
    private let rewardManager = RewardManager.RewardManager(seasonGameweekCount, seasonMonthCount);
    private var activeCanisterId = "";
    private var MAX_LEADERBOARDS_PER_CANISTER = 500;

    public func getWeeklyCanisterId(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) : async ?Text {
      let gameweekSeason = Array.find(weeklyLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])) : Bool {
        seasonEntry.0 == seasonId;
      });

      switch(gameweekSeason){
        case (?foundGameweekSeason){
          let gameweekResult = Array.find(foundGameweekSeason.1, func(gameweekEntry: (FootballTypes.GameweekNumber, Base.CanisterId)) : Bool {
            gameweekEntry.0 == gameweek
          });

          switch(gameweekResult){
            case(?foundGameweek){
              return ?foundGameweek.1;
            };
            case (null){}
          }
        };
        case (null) {}
      };

      return null;
    };

    public func getMonthlyCanisterId(seasonId : FootballTypes.SeasonId, month : Base.CalendarMonth, clubId: FootballTypes.ClubId) : async ?Text {
      let monthSeason = Array.find(monthlyLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])) : Bool {
        seasonEntry.0 == seasonId;
      });

      switch(monthSeason){
        case (?foundMonthSeason){
          let monthResult = Array.find(foundMonthSeason.1, func(monthEntry: (Base.CalendarMonth, Base.CanisterId)) : Bool {
            monthEntry.0 == month
          });

          switch(monthResult){
            case(?foundMonth){
              return ?foundMonth.1;
            };
            case (null){}
          }
        };
        case (null) {}
      };

      return null;
    };

    public func getSeasonCanisterId(seasonId : FootballTypes.SeasonId) : async ?Text {
       let seasonResult = Array.find(seasonLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, Base.CanisterId)) : Bool {
        seasonEntry.0 == seasonId;
      });

      switch(seasonResult){
        case (?foundSeason){
          return ?foundSeason.1;
        };
        case (null) {}
      };

      return null;
    };

    public func getWeeklyLeaderboard(dto: DTOs.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      await debugLog("a");
      let gameweekSeason = Array.find(weeklyLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])) : Bool {
        seasonEntry.0 == dto.seasonId;
      });

      await debugLog("b");
      switch(gameweekSeason){
        case (?foundGameweekSeason){
          let gameweekResult = Array.find(foundGameweekSeason.1, func(gameweekEntry: (FootballTypes.GameweekNumber, Base.CanisterId)) : Bool {
            gameweekEntry.0 == dto.gameweek
          });
      await debugLog("c");

          switch(gameweekResult){
            case(?foundGameweek){
              let canisterId = foundGameweek.1;

              let leaderboard_canister = actor (canisterId) : actor {
                getWeeklyLeaderboardEntries : (seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.WeeklyLeaderboardDTO;
              };

              let filters: DTOs.PaginationFiltersDTO = {
                limit = 25;
                offset = dto.offset;
              };
      await debugLog("d");

              let leaderboardEntries = await leaderboard_canister.getWeeklyLeaderboardEntries(dto.seasonId, dto.gameweek, filters, dto.searchTerm);
              switch (leaderboardEntries) {
                case (null) {
      await debugLog("e");
                  return #err(#NotFound);
                };
                case (?foundLeaderboard) {
      await debugLog("f");
                  return #ok(foundLeaderboard);
                };
              };


            };
            case (null){}
          }
        };
        case (null) {}
      };
      await debugLog("g");
      return #err(#NotFound);
    };

    public func getMonthlyLeaderboard(dto: DTOs.GetMonthlyLeaderboardDTO) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let monthSeason = Array.find(monthlyLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])) : Bool {
        seasonEntry.0 == dto.seasonId;
      });

      switch(monthSeason){
        case (?foundMonthSeason){
          let monthResult = Array.find(foundMonthSeason.1, func(monthEntry: (Base.CalendarMonth, Base.CanisterId)) : Bool {
            monthEntry.0 == dto.month
          });

          switch(monthResult){
            case(?foundMonth){
              let canisterId = foundMonth.1;
              let leaderboard_canister = actor (canisterId) : actor {
                getMonthlyLeaderboardEntries : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, clubId: FootballTypes.ClubId, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.MonthlyLeaderboardDTO;
              };
              
              let leaderboardEntries = await leaderboard_canister.getMonthlyLeaderboardEntries(dto.seasonId, dto.month, dto.clubId, dto, dto.searchTerm);
              switch (leaderboardEntries) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundLeaderboard) {
                  return #ok(foundLeaderboard);
                };
              };


            };
            case (null){}
          }
        };
        case (null) {}
      };

      return #err(#NotFound);
    };

    public func getSeasonLeaderboard(dto: DTOs.GetSeasonLeaderboardDTO) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let seasonEntryResult = Array.find(seasonLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, Base.CanisterId)) : Bool {
        seasonEntry.0 == dto.seasonId;
      });

      switch(seasonEntryResult){
        case (?foundSeason){
          let canisterId = foundSeason.1;
          let leaderboard_canister = actor (canisterId) : actor {
            getSeasonLeaderboardEntries : (seasonId: FootballTypes.SeasonId, filters: DTOs.PaginationFiltersDTO, searchTerm : Text) -> async ?DTOs.SeasonLeaderboardDTO;
          };
          
          let leaderboardEntries = await leaderboard_canister.getSeasonLeaderboardEntries(dto.seasonId, dto, dto.searchTerm);
          switch (leaderboardEntries) {
            case (null) {
              return #err(#NotFound);
            };
            case (?foundLeaderboard) {
              return #ok(foundLeaderboard);
            };
          };
        };
        case (null){}
      }; 

      return #err(#NotFound);
    };

    public func getWeeklyLeaderboardEntry(principalId : Text, seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) : async ?DTOs.LeaderboardEntryDTO {

      let gameweekSeason = Array.find(weeklyLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])) : Bool {
        seasonEntry.0 == seasonId;
      });

      switch(gameweekSeason){
        case (?foundGameweekSeason){
          let gameweekResult = Array.find(foundGameweekSeason.1, func(gameweekEntry: (FootballTypes.GameweekNumber, Base.CanisterId)) : Bool {
            gameweekEntry.0 == gameweek
          });

          switch(gameweekResult){
            case(?foundGameweek){
              let canisterId = foundGameweek.1;
              let weekly_leaderboard_canister = actor (canisterId) : actor {
                getWeeklyLeaderboardEntry : (seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber, principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
              };

              let leaderboardEntry = await weekly_leaderboard_canister.getWeeklyLeaderboardEntry(seasonId, gameweek, principalId);
              return leaderboardEntry;   
            };
            case (null){}
          }
        };
        case (null) {}
      };
      return null;
    };

    public func getMonthlyLeaderboardEntry(principalId : Text, seasonId : FootballTypes.SeasonId, month : Base.CalendarMonth, clubId : FootballTypes.ClubId) : async ?DTOs.LeaderboardEntryDTO {
      
      let monthSeason = Array.find(monthlyLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])) : Bool {
        seasonEntry.0 == seasonId;
      });

      switch(monthSeason){
        case (?foundMonthSeason){
          let monthResult = Array.find(foundMonthSeason.1, func(monthEntry: (Base.CalendarMonth, Base.CanisterId)) : Bool {
            monthEntry.0 == month
          });

          switch(monthResult){
            case(?foundMonth){
              let canisterId = foundMonth.1;
              let monthly_leaderboard_canister = actor (canisterId) : actor {
                getMonthlyLeaderboardEntry : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, clubId: FootballTypes.ClubId, principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
              };

              let leaderboardEntry = await monthly_leaderboard_canister.getMonthlyLeaderboardEntry(seasonId, month, clubId, principalId);
              return leaderboardEntry;
            };
            case (null){}
          }
        };
        case (null) {}
      };
      return null;
    };

    public func getSeasonLeaderboardEntry(principalId : Text, seasonId : FootballTypes.SeasonId) : async ?DTOs.LeaderboardEntryDTO {

      let seasonEntryResult = Array.find(seasonLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, Base.CanisterId)) : Bool {
        seasonEntry.0 == seasonId;
      });

      switch(seasonEntryResult){
        case (?foundSeason){
          let canisterId = foundSeason.1;
          
          let season_leaderboard_canister = actor (canisterId) : actor {
            getSeasonLeaderboardEntry : (seasonId: FootballTypes.SeasonId, principalId : Text) -> async ?DTOs.LeaderboardEntryDTO;
          };

          let leaderboardEntry = await season_leaderboard_canister.getSeasonLeaderboardEntry(seasonId, principalId);
          return leaderboardEntry;
        };
        case (null){}
      }; 
      return null;
    };

    public func calculateLeaderboards(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth, uniqueManagerCanisterIds : [Base.CanisterId], clubIds: [FootballTypes.ClubId]) : async () {
      
      await debugLog("Calculating leaderboards");


      if(activeCanisterId == ""){
        activeCanisterId := await createLeaderboardCanister();
      };
      
      await debugLog("Defining canister");

      var leaderboard_canister = actor (activeCanisterId) : actor {
        getTotalLeaderboards : () -> async Nat;
        addLeaderboardChunk : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber, clubId: FootballTypes.ClubId, entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber, clubId: FootballTypes.ClubId) -> async ();
        finaliseUpdate : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber) -> async ();
      };

      await debugLog("Getting total leaderboards");
      let totalLeaderboards = await leaderboard_canister.getTotalLeaderboards();

      await debugLog("Calculating leaderboards for " # Nat.toText(totalLeaderboards) # " leaderboards");
      if(totalLeaderboards >= MAX_LEADERBOARDS_PER_CANISTER){
        activeCanisterId := await createLeaderboardCanister();
      };
      
      leaderboard_canister := actor (activeCanisterId) : actor {
        getTotalLeaderboards : () -> async Nat;
        addLeaderboardChunk : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber, clubId: FootballTypes.ClubId, entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber, clubId: FootballTypes.ClubId) -> async ();
        finaliseUpdate : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber) -> async ();
      };

      /*
      if(month > 0){
        for(clubId in Iter.fromArray(clubIds)){
          await leaderboard_canister.prepareForUpdate(seasonId, month, gameweek, clubId);  
        };
      } else {
        await leaderboard_canister.prepareForUpdate(seasonId, month, gameweek, 0);
      };
      */
       await debugLog("Preparing to update");
     
      await leaderboard_canister.prepareForUpdate(seasonId, 0, gameweek, 0);
       await debugLog("Preparing complete");

      for (canisterId in Iter.fromArray(uniqueManagerCanisterIds)) {
       await debugLog("Canister id: " # canisterId);
        let manager_canister = actor (canisterId) : actor {
          getOrderedSnapshots : (seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) -> async [T.FantasyTeamSnapshot];
        };

        await debugLog("Getting ordered snapshots");
        let orderedSnapshots = await manager_canister.getOrderedSnapshots(seasonId, gameweek);
        
        await debugLog("Getting ordered snapshots complete");
        let groupedByTeam = groupByTeam(orderedSnapshots);

        await debugLog("Looping");
        for(team in groupedByTeam.entries(
        )){
          let fantasyTeamSnapshots = team.1;

          let leaderboardEntries = Array.map<T.FantasyTeamSnapshot, T.LeaderboardEntry>(
          fantasyTeamSnapshots,
            func(snapshot) {
              return createLeaderboardEntry(snapshot.principalId, snapshot.username, snapshot.points);
            },
          );

          await debugLog("Adding chunk 1");
          await leaderboard_canister.addLeaderboardChunk(seasonId, 0, 0, 0, leaderboardEntries);

          await debugLog("Adding chunk 2");
          await leaderboard_canister.addLeaderboardChunk(seasonId, 0, gameweek, 0, leaderboardEntries);
          /*
          for(clubId in Iter.fromArray(clubIds)){
            await leaderboard_canister.addLeaderboardChunk(seasonId, month, 0, clubId, leaderboardEntries);
          };
          */
        };
      };

      await debugLog("Finalising update");
      await leaderboard_canister.finaliseUpdate(seasonId, 0, gameweek);

      //store the canister id
      if(gameweek == 0 and month == 0){
        //store season canister reference
        let seasonCanisterIdsBuffer = Buffer.fromArray<(FootballTypes.SeasonId, Base.CanisterId)>(seasonLeaderboardCanisters);
        seasonCanisterIdsBuffer.add(seasonId, activeCanisterId);
        seasonLeaderboardCanisters := Buffer.toArray(seasonCanisterIdsBuffer);
        return;
      };

      if(month == 0){
        //store gameweek canister
        let gameweekCanisterIdsBuffer = Buffer.fromArray<(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])>(weeklyLeaderboardCanisters);
        gameweekCanisterIdsBuffer.add(seasonId, [(gameweek, activeCanisterId)]);
        weeklyLeaderboardCanisters := Buffer.toArray(gameweekCanisterIdsBuffer);
        return
      };

      //store month canister id
        let monthCanisterIdsBuffer = Buffer.fromArray<(FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])>(monthlyLeaderboardCanisters);
        monthCanisterIdsBuffer.add(seasonId, [(month, activeCanisterId)]);
        monthlyLeaderboardCanisters := Buffer.toArray(monthCanisterIdsBuffer);
     

    };

    private func groupByTeam(snapshots : [T.FantasyTeamSnapshot]) : TrieMap.TrieMap<FootballTypes.ClubId, [T.FantasyTeamSnapshot]> {
      let groupedTeams : TrieMap.TrieMap<FootballTypes.ClubId, [T.FantasyTeamSnapshot]> = TrieMap.TrieMap<FootballTypes.ClubId, [T.FantasyTeamSnapshot]>(Utilities.eqNat16, Utilities.hashNat16);

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
      let canister = await LeaderboardCanister._LeaderboardCanister();
      await canister.initialise(controllerPrincipalId);
      let IC : Management.Management = actor (NetworkEnvVars.Default);
      let principal = ?Principal.fromText(controllerPrincipalId);
      let _ = await Utilities.updateCanister_(canister, principal, IC);
      
      let canister_principal = Principal.fromActor(canister);
      let canisterId = Principal.toText(canister_principal);

      if (canisterId == "") {
        return canisterId;
      };
      
      let uniqueCanisterIdBuffer = Buffer.fromArray<Base.CanisterId>(uniqueLeaderboardCanisterIds);
      uniqueCanisterIdBuffer.add(canisterId);
      uniqueLeaderboardCanisterIds := Buffer.toArray(uniqueCanisterIdBuffer);

      return canisterId;
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

    public func getLeaderboardCanisters() : [Base.CanisterId] {
        return uniqueLeaderboardCanisterIds;
    };

    public func getRewardPool(seasonId: FootballTypes.SeasonId) : ?T.RewardPool {
        return rewardManager.getRewardPool(seasonId);
    };

    public func payWeeklyRewards() : async () {
      //TODO (PAYOUT)
      /* Removed inputs but what should be passed
      weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO, filters: DTOs.GameweekFiltersDTO, fixtures : List.List<DTOs.FixtureDTO>, uniqueManagerCanisterIds: List.List<T.CanisterId>
      */
      /*
      await rewardManager.distributeWeeklyRewards(weeklyLeaderboard);
      await rewardManager.distributeHighestScoringPlayerRewards(filters.seasonId, filters.gameweek, fixtures, uniqueManagerCanisterIds);
      await rewardManager.distributeWeeklyATHScoreRewards(weeklyLeaderboard);
      */
    };

    public func payMonthlyRewards() : async () {
      //TODO (PAYOUT)
      /* Removed inputs but what should be passed
        seasonId: FootballTypes.SeasonId, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO], uniqueManagerCanisterIds: List.List<T.CanisterId>
      */
      /*
        await rewardManager.distributeMonthlyRewards(seasonId, monthlyLeaderboards, uniqueManagerCanisterIds);
        await rewardManager.distributeMonthlyATHScoreRewards(seasonId, monthlyLeaderboards);
      */
    };

    public func paySeasonRewards() : async () {
      //TODO (PAYOUT)
      /* Removed inputs but what should be passed
      seasonLeaderboard : DTOs.SeasonLeaderboardDTO, players : [DTOs.PlayerDTO], seasonId : FootballTypes.SeasonId, uniqueManagerCanisterIds: List.List<T.CanisterId>
      */
      /*
      await rewardManager.distributeSeasonRewards(seasonLeaderboard);
      await rewardManager.distributeSeasonATHScoreRewards(seasonLeaderboard);
      await rewardManager.distributeMostValuableTeamRewards(players, seasonId, uniqueManagerCanisterIds);
      */
    };

    //TODO (NOW): Ensure used

    //Statble Storage 

    public func getStableRewardPools() : [(FootballTypes.SeasonId, T.RewardPool)]{
      return rewardManager.getStableRewardPools();
    };

    public func setStableRewardPools(stable_reward_pools: [(FootballTypes.SeasonId, T.RewardPool)]){
      rewardManager.setStableRewardPools(stable_reward_pools);
    };

    public func getStableUniqueLeaderboardCanisterIds() : [Base.CanisterId] {
      return uniqueLeaderboardCanisterIds;
    };

    public func setStableUniqueLeaderboardCanisterIds(stable_leaderboard_canister_ids : [Base.CanisterId]) {
      uniqueLeaderboardCanisterIds := stable_leaderboard_canister_ids;
    };

    public func getStableWeeklyLeaderboardCanisterIds() : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])] {
      return weeklyLeaderboardCanisters;
    };

    public func setStableWeeklyLeaderboardCanisterIds(leaderboard_canisters : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])]) {
      weeklyLeaderboardCanisters := leaderboard_canisters;
    };

    public func getStableMonthlyLeaderboardCanisterIds() : [(FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])] {
      return monthlyLeaderboardCanisters;
    };

    public func setStableMonthlyLeaderboardCanisterIds(leaderboard_canisters : [(FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])]) {
      monthlyLeaderboardCanisters := leaderboard_canisters;
    };

    public func getStableSeasonLeaderboardCanisterIds() : [(FootballTypes.SeasonId, Base.CanisterId)] {
      return seasonLeaderboardCanisters;
    };

    public func setStableSeasonLeaderboardCanisterIds(leaderboard_canisters : [(FootballTypes.SeasonId, Base.CanisterId)]) {
      seasonLeaderboardCanisters := leaderboard_canisters;
    };

    public func getStableTeamValueLeaderboards() : [(FootballTypes.SeasonId, T.TeamValueLeaderboard)] {
      return rewardManager.getStableTeamValueLeaderboards();
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

    public func setStableTeamValueLeaderboards(stable_team_value_leaderboards : [(FootballTypes.SeasonId, T.TeamValueLeaderboard)]) {
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

    public func getStableActiveCanisterId() : Base.CanisterId {
      return activeCanisterId;
    };

    public func setStableActiveCanisterId(stable_active_canister_id: Base.CanisterId){
      activeCanisterId := stable_active_canister_id;
    };

    private func debugLog(text: Text) : async (){
      let waterway_labs_canister = actor (NetworkEnvironmentVariables.WATERWAY_LABS_BACKEND_CANISTER_ID) : actor {
        logSystemEvent : (dto: DTOs.SystemEventDTO) -> async ();
      };

      await waterway_labs_canister.logSystemEvent({
        eventDetail = text;
        eventId = 0;
        eventTime = Time.now();
        eventTitle = "DEBUG";
        eventType = #SystemCheck;
      });

    };
  };
};