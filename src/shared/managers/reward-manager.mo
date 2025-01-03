import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Result "mo:base/Result";
import Debug "mo:base/Debug";

import Account "../../shared/lib/Account";
import Constants "../../shared/utils/Constants";
import DTOs "../../shared/dtos/DTOs";
import RewardPercentages "../../shared/utils/RewardPercentages";
import SNSToken "../../shared/sns-wrappers/ledger";
import Base "../../shared/types/base_types";
import FootballTypes "../../shared/types/football_types";
import T "../../shared/types/app_types";
import Utilities "../../shared/utils/utilities";
import NetworkEnvironmentVariables "../network_environment_variables";

module {

  public class RewardManager() {

    private var rewardPools : TrieMap.TrieMap<FootballTypes.SeasonId, T.RewardPool> = TrieMap.TrieMap<FootballTypes.SeasonId, T.RewardPool>(Utilities.eqNat16, Utilities.hashNat16);
    private var teamValueLeaderboards : TrieMap.TrieMap<FootballTypes.SeasonId, T.TeamValueLeaderboard> = TrieMap.TrieMap<FootballTypes.SeasonId, T.TeamValueLeaderboard>(Utilities.eqNat16, Utilities.hashNat16);

    private var seasonRewards : List.List<T.SeasonRewards> = List.nil();
    private var monthlyRewards : List.List<T.MonthlyRewards> = List.nil();
    private var weeklyRewards : List.List<T.WeeklyRewards> = List.nil();
    private var mostValuableTeamRewards : List.List<T.RewardsList> = List.nil();
    private var highScoringPlayerRewards : List.List<T.RewardsList> = List.nil();

    private var weeklyAllTimeHighScores : List.List<T.HighScoreRecord> = List.nil();
    private var monthlyAllTimeHighScores : List.List<T.HighScoreRecord> = List.nil();
    private var seasonAllTimeHighScores : List.List<T.HighScoreRecord> = List.nil();

    private var weeklyATHPrizePool : Nat64 = 0;
    private var monthlyATHPrizePool : Nat64 = 0;
    private var seasonATHPrizePool : Nat64 = 0;

    public func calculateGameweekRewards(dto: DTOs.WeeklyLeaderboardDTO, seasonGameweekCount: Nat8): async () {
      let weeklyRewardsExcludingThisWeek = List.filter<T.WeeklyRewards>(weeklyRewards, func(weeklyRewardsEntry: T.WeeklyRewards){
        not (weeklyRewardsEntry.gameweek == dto.gameweek and weeklyRewardsEntry.seasonId == dto.seasonId)
      });
      let weeklyRewardsBuffer = Buffer.fromArray<T.WeeklyRewards>(List.toArray(weeklyRewardsExcludingThisWeek));

      let rewardPoolOpt = rewardPools.get(dto.seasonId);

      switch (rewardPoolOpt) {
          case (?rewardPool) {
              let weeklyRewardAmount = rewardPool.weeklyLeaderboardPool / Nat64.fromNat(Nat8.toNat(seasonGameweekCount));              
              let topEntries = filterTop100IncludingTies(dto.entries);
              
              var scaledPercentages: [Float] = RewardPercentages.percentages;
              if(Array.size(topEntries) < 100){
                scaledPercentages := scalePercentages(RewardPercentages.percentages, Array.size(topEntries));
              };

              let payoutPercentages = spreadPercentagesOverEntries(topEntries, scaledPercentages);
              
              let rewardEntriesBuffer = Buffer.fromArray<T.RewardEntry>([]);
              for (i in Iter.range(0, payoutPercentages.size() - 1)) {
                  
                  let winner = topEntries[i];
                  let totalPrizePoolE8s: Nat64 = weeklyRewardAmount * 100_000_000;
                  let userPrizeE8s = Float.fromInt64(Int64.fromNat64(totalPrizePoolE8s)) * payoutPercentages[i];

                  rewardEntriesBuffer.add({
                      principalId = winner.principalId;
                      rewardType = #WeeklyLeaderboard;
                      position = topEntries[i].position;
                      amount = Int64.toNat64(Float.toInt64(userPrizeE8s));
                  });
              };

              let newWeeklyRewardsEntry: T.WeeklyRewards = {
                  seasonId = dto.seasonId;
                  gameweek = dto.gameweek;
                  rewards = List.fromArray(Buffer.toArray(rewardEntriesBuffer));
              };
              weeklyRewardsBuffer.add(newWeeklyRewardsEntry);
          };
          case (null) {
          };
      };
      
      weeklyRewards := List.fromArray(Buffer.toArray(weeklyRewardsBuffer));
    };

    private func filterTop100IncludingTies(entries: [T.LeaderboardEntry]) : [T.LeaderboardEntry] {
      let entryBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
      
      var maxPosition = 100; // Define the cutoff threshold
      var lastPosition = 0;  // Track the last position added to handle ties

      label tieLoop for (entry in entries.vals()) {
          // Stop if we've exceeded the max position and the entry isn't tied
          if (entry.position > maxPosition and entry.position != lastPosition) {
              break tieLoop;
          };

          // Add the entry to the buffer
          entryBuffer.add(entry);
          lastPosition := entry.position; // Update the last position
      };
      
      Buffer.toArray(entryBuffer);
    };

    private func scalePercentages(percentages: [Float], actualWinners: Nat): [Float] {
    
      let winnerPercentages = Array.subArray<Float>(percentages, 0, Nat.min(Array.size(percentages), actualWinners));
      let adjustedBuffer = Buffer.fromArray<Float>(winnerPercentages);

      if (actualWinners < Array.size(percentages)) {
          let assignedSum = Array.foldLeft<Float, Float>(winnerPercentages, 0.0, func(x, y) { x + y });
          let unassignedSum = Array.foldLeft<Float, Float>(Array.subArray<Float>(percentages, actualWinners, Array.size(percentages) - actualWinners), 0.0, func(x, y) { x + y });

          adjustedBuffer.clear();
          for (p in winnerPercentages.vals()) {
              let proportionalShare = (p / assignedSum) * 100.0;
              let additionalShare = (unassignedSum * p / assignedSum);
              adjustedBuffer.add(proportionalShare + additionalShare);
          }
      } else {
          adjustedBuffer.clear();
          for (p in winnerPercentages.vals()) {
              adjustedBuffer.add(p);
          };
      };

      return Buffer.toArray<Float>(adjustedBuffer); 
    };
    
    private func spreadPercentagesOverEntries(
        sortedEntries: [T.LeaderboardEntry],
        scaledPercentages: [Float]
      ): [Float] {
        
        let adjustedPercentagesBuffer = Buffer.fromArray<Float>(scaledPercentages);

        var i: Nat = 0;

        while (i < Array.size(sortedEntries)) {
            var tieCount: Nat = 1;
            var totalPercentage: Float = if (i < Array.size(scaledPercentages)) {
                scaledPercentages[i]
            } else {
                0.0;
            };

            // Check for tied entries
            while (
                i + tieCount < Array.size(sortedEntries) and 
                sortedEntries[i + tieCount].points == sortedEntries[i].points
            ) {
                if (i + tieCount < Array.size(scaledPercentages)) {
                    totalPercentage += scaledPercentages[i + tieCount];
                };
                tieCount += 1;
            };

            // Calculate average percentage for tied entries
            let averagePercentage = totalPercentage / Float.fromInt(tieCount);

            // Update the buffer for tied entries
            for (j in Iter.range(i, i + tieCount - 1)) {
                if (j < adjustedPercentagesBuffer.size()) {
                    adjustedPercentagesBuffer.put(j, averagePercentage);
                } else {
                    adjustedPercentagesBuffer.add(averagePercentage); // Add if beyond buffer size
                };
            };

            // Move to the next group of entries
            i += tieCount;
        };

        // Adjust percentages to ensure they sum to 1 using Buffer
        let adjustedPercentages = Buffer.toArray(adjustedPercentagesBuffer);
        let sumPercentages = Array.foldLeft<Float, Float>(
            adjustedPercentages,
            0.0,
            func(acc, x) { acc + x }
        );

        if (sumPercentages != 1.0) {
            let adjustmentFactor = 1.0 / sumPercentages;

            // Adjust using Buffer
            for (i in Iter.range(0, adjustedPercentagesBuffer.size() - 1)) {
                let updatedValue = adjustedPercentagesBuffer.get(i) * adjustmentFactor;
                adjustedPercentagesBuffer.put(i, updatedValue);
            };
        };

        return Buffer.toArray(adjustedPercentagesBuffer);
    };


    public func getWeeklyRewards(seasonId: FootballTypes.SeasonId, gameweek: FootballTypes.GameweekNumber) : Result.Result<T.WeeklyRewards, T.Error> {
      
      let rewards = List.find(weeklyRewards, func(rewardsEntry: T.WeeklyRewards) : Bool {
        rewardsEntry.seasonId == seasonId and rewardsEntry.gameweek == gameweek;
      });

      switch(rewards){
        case (?foundRewards){
          return #ok(foundRewards);
        };
        case (null){}
      };
      
      return #err(#NotFound);
    };

    private func payReward(principalId : Base.PrincipalId, fpl : Nat64) : async () {
      let ledger : SNSToken.Interface = actor (NetworkEnvironmentVariables.SNS_LEDGER_CANISTER_ID);
      
      let _ = await ledger.icrc1_transfer ({
        memo = ?Text.encodeUtf8("0");
        from_subaccount = ?Account.defaultSubaccount();
        to = {owner = Principal.fromText(principalId); subaccount = null};
        amount = Nat64.toNat(fpl);
        fee = ?Nat64.toNat(Constants.FPL_TRANSACTION_FEE);
        created_at_time = ?Nat64.fromNat(Int.abs(Time.now()))
      });
    };

    public func getRewardPool(seasonId: FootballTypes.SeasonId) : ?T.RewardPool {
        return rewardPools.get(seasonId);
    };
    
    public func getStableRewardPools() : [(FootballTypes.SeasonId, T.RewardPool)] {
      Iter.toArray(rewardPools.entries());
    };

    public func setStableRewardPools(stable_reward_pools : [(FootballTypes.SeasonId, T.RewardPool)]) {
      rewardPools := TrieMap.fromEntries<FootballTypes.SeasonId, T.RewardPool>(
        Iter.fromArray(stable_reward_pools),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    }; 

    public func getStableTeamValueLeaderboards() : [(FootballTypes.SeasonId, T.TeamValueLeaderboard)] {
      return Iter.toArray(teamValueLeaderboards.entries());
    };

    public func setStableTeamValueLeaderboards(stable_team_value_leaderboards : [(FootballTypes.SeasonId, T.TeamValueLeaderboard)]) {
      teamValueLeaderboards := TrieMap.fromEntries<FootballTypes.SeasonId, T.TeamValueLeaderboard>(
        Iter.fromArray(stable_team_value_leaderboards),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    };

    public func getStableWeeklyRewards() : [T.WeeklyRewards] {
      return List.toArray(weeklyRewards);
    };

    public func setStableWeeklyRewards(stable_weekly_rewards : [T.WeeklyRewards]) {
      weeklyRewards := List.fromArray(stable_weekly_rewards);
    };

    public func getStableMonthlyRewards() : [T.MonthlyRewards] {
      return List.toArray(monthlyRewards);
    };

    public func setStableMonthlyRewards(stable_monthly_rewards : [T.MonthlyRewards]) {
      monthlyRewards := List.fromArray(stable_monthly_rewards);
    };

    public func getStableSeasonRewards() : [T.SeasonRewards] {
      return List.toArray(seasonRewards);
    };

    public func setStableSeasonRewards(stable_season_rewards : [T.SeasonRewards]) {
      seasonRewards := List.fromArray(stable_season_rewards);
    };

    public func getStableMostValuableTeamRewards() : [T.RewardsList] {
      return List.toArray(mostValuableTeamRewards);
    };

    public func setStableMostValuableTeamRewards(stable_most_valuable_team_rewards : [T.RewardsList]) {
      mostValuableTeamRewards := List.fromArray(stable_most_valuable_team_rewards);
    };

    public func getStableHighestScoringPlayerRewards() : [T.RewardsList] {
      return List.toArray(highScoringPlayerRewards);
    };

    public func setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards : [T.RewardsList]) {
      highScoringPlayerRewards := List.fromArray(stable_highest_scoring_player_rewards);
    };

    public func getStableWeeklyAllTimeHighScores() : [T.HighScoreRecord] {
      return List.toArray(weeklyAllTimeHighScores);
    };

    public func setStableWeeklyAllTimeHighScores(stable_weekly_ath_scores : [T.HighScoreRecord]) {
      weeklyAllTimeHighScores := List.fromArray(stable_weekly_ath_scores);
    };

    public func getStableMonthlyAllTimeHighScores() : [T.HighScoreRecord] {
      return List.toArray(monthlyAllTimeHighScores);
    };

    public func setStableMonthlyAllTimeHighScores(stable_monthly_ath_scores : [T.HighScoreRecord]) {
      monthlyAllTimeHighScores := List.fromArray(stable_monthly_ath_scores);
    };

    public func getStableSeasonAllTimeHighScores() : [T.HighScoreRecord] {
      return List.toArray(seasonAllTimeHighScores);
    };

    public func setStableSeasonAllTimeHighScores(stable_season_ath_scores : [T.HighScoreRecord]) {
      seasonAllTimeHighScores := List.fromArray(stable_season_ath_scores);
    };

    public func getStableWeeklyATHPrizePool() : Nat64 {
      return weeklyATHPrizePool;
    };

    public func setStableWeeklyATHPrizePool(stable_weekly_ath_prize_pool : Nat64) {
      weeklyATHPrizePool := stable_weekly_ath_prize_pool;
    };

    public func getStableMonthlyATHPrizePool() : Nat64 {
      return monthlyATHPrizePool;
    };

    public func setStableMonthlyATHPrizePool(stable_monthly_ath_prize_pool : Nat64) {
      monthlyATHPrizePool := stable_monthly_ath_prize_pool;
    };

    public func getStableSeasonATHPrizePool() : Nat64 {
      return seasonATHPrizePool;
    };

    public func setStableSeasonATHPrizePool(stable_season_ath_prize_pool : Nat64) {
      seasonATHPrizePool := stable_season_ath_prize_pool;
    };

    /* Temporary Functions to be removed */
    /*
    public func setupRewardPool(){
      rewardPools.put(1, {
        allTimeMonthlyHighScorePool = 46875;
        allTimeSeasonHighScorePool = 46875;
        allTimeWeeklyHighScorePool = 46875;
        highestScoringMatchPlayerPool = 93750;
        monthlyLeaderboardPool = 328125;
        mostValuableTeamPool = 93750;
        seasonId= 1;
        seasonLeaderboardPool = 140625;
        weeklyLeaderboardPool = 140625;
      });
    };
    */

  };
};
