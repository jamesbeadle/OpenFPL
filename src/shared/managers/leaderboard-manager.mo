
import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import DTOs "../../shared/dtos/dtos";
import Base "../../shared/types/base_types";
import FootballTypes "mo:football-types";
import T "../../shared/types/app_types";
import ComparisonUtilities "../../shared/utils/type_comparison_utilities";
import CanisterUtilities "../../shared/utils/canister_utilities";
import Management "../../shared/utils/Management";
import NetworkEnvVars "../network_environment_variables";
import LeaderboardCanister "../canister_definitions/leaderboard-canister";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import RewardManager "reward-manager";
import NetworkEnvironmentVariables "../network_environment_variables";
import SNSToken "../../shared/sns-wrappers/ledger";
import Account "../lib/Account";
import Constants "../../shared/def/Constants";
import Queries "../cqrs/queries";

module {

  public class LeaderboardManager(controllerPrincipalId: Text) {
   
    private var uniqueLeaderboardCanisterIds: [Base.CanisterId] = [];
    private var weeklyLeaderboardCanisters : [(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])] = [];
    private var monthlyLeaderboardCanisters : [(FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])] = [];
    private var seasonLeaderboardCanisters : [(FootballTypes.SeasonId, Base.CanisterId)] = [];
     
    private let rewardManager = RewardManager.RewardManager();
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

    public func getWeeklyLeaderboard(dto: Queries.GetWeeklyLeaderboardDTO) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      if (dto.limit > 100) {
        return #err(#NotAllowed);
      };

      let gameweekSeason = Array.find(weeklyLeaderboardCanisters, func(seasonEntry: (FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])) : Bool {
        seasonEntry.0 == dto.seasonId;
      });

      switch(gameweekSeason){
        case (?foundGameweekSeason){
          let gameweekResult = Array.find(foundGameweekSeason.1, func(gameweekEntry: (FootballTypes.GameweekNumber, Base.CanisterId)) : Bool {
            gameweekEntry.0 == dto.gameweek
          });
      
          switch(gameweekResult){
            case(?foundGameweek){
              let canisterId = foundGameweek.1;

              let leaderboard_canister = actor (canisterId) : actor {
                getWeeklyLeaderboardEntries : (dto: Queries.GetWeeklyLeaderboardEntriesDTO) -> async ?DTOs.WeeklyLeaderboardDTO;
              };

              let entriesDTO: Queries.GetWeeklyLeaderboardEntriesDTO = {
                gameweek = foundGameweek.0;
                offset = dto.offset;
                searchTerm = dto.searchTerm;
                seasonId = foundGameweekSeason.0;
              };

              let leaderboardEntries = await leaderboard_canister.getWeeklyLeaderboardEntries(entriesDTO);
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

    public func calculateLeaderboards(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, month : Base.CalendarMonth, uniqueManagerCanisterIds : [Base.CanisterId]) : async () {
      if(activeCanisterId == ""){
        activeCanisterId := await createLeaderboardCanister();
      };
      
      var leaderboard_canister = actor (activeCanisterId) : actor {
        getTotalLeaderboards : () -> async Nat;
        addLeaderboardChunk : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber, clubId: FootballTypes.ClubId, entriesChunk : [T.LeaderboardEntry]) -> async ();
        prepareForUpdate : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber, clubId: FootballTypes.ClubId) -> async ();
        finaliseUpdate : (seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth, gameweek: FootballTypes.GameweekNumber) -> async ();
      };

      let totalLeaderboards = await leaderboard_canister.getTotalLeaderboards();

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
      //TODO: Need a way to separate out month as before we had the leaderboards in individual canisters but now we have them in a single canister
      if(month > 0){
        for(clubId in Iter.fromArray(clubIds)){
          await leaderboard_canister.prepareForUpdate(seasonId, month, gameweek, clubId);  
        };
      } else {
        await leaderboard_canister.prepareForUpdate(seasonId, month, gameweek, 0);
      };
      */
     
      await leaderboard_canister.prepareForUpdate(seasonId, 0, gameweek, 0);
      for (canisterId in Iter.fromArray(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getOrderedSnapshots : (seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber) -> async [T.FantasyTeamSnapshot];
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

          //await leaderboard_canister.addLeaderboardChunk(seasonId, 0, 0, 0, leaderboardEntries);

          await leaderboard_canister.addLeaderboardChunk(seasonId, 0, gameweek, 0, leaderboardEntries);
          /*
          for(clubId in Iter.fromArray(clubIds)){
            await leaderboard_canister.addLeaderboardChunk(seasonId, month, 0, clubId, leaderboardEntries);
          };
          */
        };
      };

      await leaderboard_canister.finaliseUpdate(seasonId, 0, gameweek);
    
      if(gameweek == 0 and month == 0){
        addSeasonLeaderboardCanisterId(seasonId);
        return;
      };

      if(month == 0){
        addWeeklyLeaderboardCanisterId(seasonId, gameweek);
        return;
      };

      addMonthlyLeaderboardCanisterId(seasonId, month);

    };

    private func addSeasonLeaderboardCanisterId(seasonId: FootballTypes.SeasonId){
      let seasonCanisterIdsBuffer = Buffer.fromArray<(FootballTypes.SeasonId, Base.CanisterId)>(seasonLeaderboardCanisters);
      seasonCanisterIdsBuffer.add(seasonId, activeCanisterId);
      seasonLeaderboardCanisters := Buffer.toArray(seasonCanisterIdsBuffer);
    };
    
    private func addWeeklyLeaderboardCanisterId(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber){
        
        let weeklyLeaderboardCanisterBuffer = Buffer.fromArray<(FootballTypes.SeasonId, [(FootballTypes.GameweekNumber, Base.CanisterId)])>([]);
        var seasonExists = false;

        for(canister in Iter.fromArray(weeklyLeaderboardCanisters)){
          if(canister.0 == seasonId){
            let gameweekBuffer = Buffer.fromArray<(FootballTypes.GameweekNumber, Base.CanisterId)>([]);
            var gameweekFound = false;
            for(existingGameweek in Iter.fromArray(canister.1)){
              if(existingGameweek.0 == gameweek){
                gameweekBuffer.add(existingGameweek.0, activeCanisterId);
                gameweekFound := true;
              } else {
                gameweekBuffer.add(existingGameweek);
              }
            };

            if(not gameweekFound){
              gameweekBuffer.add(gameweek, activeCanisterId);
            };
            weeklyLeaderboardCanisterBuffer.add((canister.0, Buffer.toArray(gameweekBuffer)));
            seasonExists := true;
          } else {
            weeklyLeaderboardCanisterBuffer.add(canister);
          }
        };

        if(not seasonExists){
            weeklyLeaderboardCanisterBuffer.add(seasonId, [(gameweek, activeCanisterId)]);
        };
        
        weeklyLeaderboardCanisters := Buffer.toArray(weeklyLeaderboardCanisterBuffer);
    };

    private func addMonthlyLeaderboardCanisterId(seasonId: FootballTypes.SeasonId, month: Base.CalendarMonth){

      let monthCanisterIdsBuffer = Buffer.fromArray<(FootballTypes.SeasonId, [(Base.CalendarMonth, Base.CanisterId)])>(monthlyLeaderboardCanisters);
      monthCanisterIdsBuffer.add(seasonId, [(month, activeCanisterId)]);
      monthlyLeaderboardCanisters := Buffer.toArray(monthCanisterIdsBuffer);
    };

    private func groupByTeam(snapshots : [T.FantasyTeamSnapshot]) : TrieMap.TrieMap<FootballTypes.ClubId, [T.FantasyTeamSnapshot]> {
      let groupedTeams : TrieMap.TrieMap<FootballTypes.ClubId, [T.FantasyTeamSnapshot]> = TrieMap.TrieMap<FootballTypes.ClubId, [T.FantasyTeamSnapshot]>(ComparisonUtilities.eqNat16, ComparisonUtilities.hashNat16);

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
      let _ = await CanisterUtilities.updateCanister_(canister, principal, IC);
      
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

    public func getUniqueLeaderboardCanisterIds() : [Base.CanisterId] {
        return uniqueLeaderboardCanisterIds;
    };
    
    public func calculateWeeklyRewards(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error>{
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

              let leaderboard_canister = actor (canisterId) : actor {
                getWeeklyRewardWinners : (dto: Queries.GetWeeklyRewardWinnersDTO) -> async ?DTOs.WeeklyLeaderboardDTO;
              };
              
              let entriesDTO: Queries.GetWeeklyRewardWinnersDTO = {
                seasonId = foundGameweekSeason.0;
                gameweek = foundGameweek.0;
              };

              let leaderboardEntries = await leaderboard_canister.getWeeklyRewardWinners(entriesDTO);

              switch (leaderboardEntries) {
                case (null) {
                  return #err(#NotFound);
                };
                case (?foundLeaderboard) {
                  await rewardManager.calculateGameweekRewards(foundLeaderboard);
                  return #ok();
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

    public func getWeeklyRewards(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : Result.Result<T.WeeklyRewards, T.Error> {
      return rewardManager.getWeeklyRewards(seasonId, gameweek);
    };

    public func getActiveRewardRates() : T.RewardRates {
        return rewardManager.getActiveRewardRates();
    };

    public func payWeeklyRewards(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : async Result.Result<(), T.Error>{
      
      let weeklyRewards = rewardManager.getWeeklyRewards(seasonId, gameweek);
      switch(weeklyRewards){
        case (#ok rewardEntries){
        
        for(entry in Iter.fromList(rewardEntries.rewards)){
          let ledger : SNSToken.Interface = actor (NetworkEnvironmentVariables.SNS_LEDGER_CANISTER_ID);
          
          let _ = await ledger.icrc1_transfer ({
            memo = ?Text.encodeUtf8("0");
            from_subaccount = ?Account.defaultSubaccount();
            to = {owner = Principal.fromText(entry.principalId); subaccount = null};
            amount = Nat64.toNat(entry.amount);
            fee = ?Nat64.toNat(Constants.FPL_TRANSACTION_FEE);
            created_at_time = ?Nat64.fromNat(Int.abs(Time.now()))
          });
        };
        return #ok();
      };
      case (#err error){
        return #err(error);
      }
      };
    };

    //Statble Storage 

    public func getStableActiveRewardRates() : T.RewardRates{
      return rewardManager.getStableActiveRewardRates();
    };

    public func setStableActiveRewardRates(stable_active_reward_rates: T.RewardRates){
      rewardManager.setStableActiveRewardRates(stable_active_reward_rates);
    };

    public func getStableHistoricRewardRates() : [T.RewardRates]{
      return rewardManager.getStableHistoricRewardRates();
    };

    public func setStableHistoricRewardRates(stable_historic_reward_rates: [T.RewardRates]){
      rewardManager.setStableHistoricRewardRates(stable_historic_reward_rates);
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

  };
};