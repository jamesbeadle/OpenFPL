import Result "mo:base/Result";
import TrieMap "mo:base/TrieMap";
import Principal "mo:base/Principal";
import Base "mo:waterway-mops/BaseTypes";
import Ids "mo:waterway-mops/Ids";
import Enums "mo:waterway-mops/Enums";
import Management "mo:waterway-mops/Management";
import CanisterUtilities "mo:waterway-mops/CanisterUtilities";
import CanisterIds "mo:waterway-mops/CanisterIds";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import BaseUtilities "mo:waterway-mops/BaseUtilities";
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
import AppTypes "../types/app_types";
import LeaderboardQueries "../queries/leaderboard_queries";
import LeaderboardCanister "../canister_definitions/leaderboard-canister";

module {

  public class LeaderboardManager() {

    private var uniqueLeaderboardCanisterIds : [Ids.CanisterId] = [];
    private var weeklyLeaderboardCanisters : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, Ids.CanisterId)])] = [];
    private var monthlyLeaderboardCanisters : [(FootballIds.SeasonId, [(BaseDefinitions.CalendarMonth, Ids.CanisterId)])] = [];
    private var seasonLeaderboardCanisters : [(FootballIds.SeasonId, Ids.CanisterId)] = [];

    private let rewardManager = RewardManager.RewardManager();
    private var activeCanisterId = "";
    private var MAX_LEADERBOARDS_PER_CANISTER = 500;

    private let DEFAULT_PAGINATION_COUNT = 10;


    public func getWeeklyLeaderboard(dto : LeaderboardQueries.GetWeeklyLeaderboard) : async Result.Result<LeaderboardQueries.WeeklyLeaderboard, Enums.Error> {
      
      let gameweekSeason = Array.find(
        weeklyLeaderboardCanisters,
        func(seasonEntry : (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, Ids.CanisterId)])) : Bool {
          seasonEntry.0 == dto.seasonId;
        },
      );

      switch (gameweekSeason) {
        case (?foundGameweekSeason) {
          let gameweekResult = Array.find(
            foundGameweekSeason.1,
            func(gameweekEntry : (FootballDefinitions.GameweekNumber, Ids.CanisterId)) : Bool {
              gameweekEntry.0 == dto.gameweek;
            },
          );

          switch (gameweekResult) {
            case (?foundGameweek) {
              let canisterId = foundGameweek.1;

              let leaderboard_canister = actor (canisterId) : actor {
                getWeeklyLeaderboardEntries : (dto : LeaderboardQueries.GetWeeklyLeaderboard) -> async ?LeaderboardQueries.WeeklyLeaderboard;
              };

              let entriesDTO : LeaderboardQueries.GetWeeklyLeaderboard = {
                gameweek = foundGameweek.0;
                page = dto.page;
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
            case (null) {};
          };
        };
        case (null) {};
      };
      return #err(#NotFound);
    };

    public func getWeeklyLeaderboardEntry(principalId : Text, seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber) : async ?AppTypes.LeaderboardEntry {

      let gameweekSeason = Array.find(
        weeklyLeaderboardCanisters,
        func(seasonEntry : (FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, Ids.CanisterId)])) : Bool {
          seasonEntry.0 == seasonId;
        },
      );

      switch (gameweekSeason) {
        case (?foundGameweekSeason) {
          let gameweekResult = Array.find(
            foundGameweekSeason.1,
            func(gameweekEntry : (FootballDefinitions.GameweekNumber, Ids.CanisterId)) : Bool {
              gameweekEntry.0 == gameweek;
            },
          );

          switch (gameweekResult) {
            case (?foundGameweek) {
              let canisterId = foundGameweek.1;
              let weekly_leaderboard_canister = actor (canisterId) : actor {
                getWeeklyLeaderboardEntry : (seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, principalId : Text) -> async ?AppTypes.LeaderboardEntry;
              };

              let leaderboardEntry = await weekly_leaderboard_canister.getWeeklyLeaderboardEntry(seasonId, gameweek, principalId);
              return leaderboardEntry;
            };
            case (null) {};
          };
        };
        case (null) {};
      };
      return null;
    };

    public func getMonthlyLeaderboard(dto: LeaderboardQueries.GetMonthlyLeaderboard) : async Result.Result<LeaderboardQueries.MonthlyLeaderboard, Enums.Error> {
      // TODO
      return #err(#NotFound);
    };

    public func getMonthlyLeaderboardEntry(principalId : Text, seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth, clubId : FootballIds.ClubId) : async ?LeaderboardQueries.LeaderboardEntry {

      let monthSeason = Array.find(
        monthlyLeaderboardCanisters,
        func(seasonEntry : (FootballIds.SeasonId, [(BaseDefinitions.CalendarMonth, Ids.CanisterId)])) : Bool {
          seasonEntry.0 == seasonId;
        },
      );

      switch (monthSeason) {
        case (?foundMonthSeason) {
          let monthResult = Array.find(
            foundMonthSeason.1,
            func(monthEntry : (BaseDefinitions.CalendarMonth, Ids.CanisterId)) : Bool {
              monthEntry.0 == month;
            },
          );

          switch (monthResult) {
            case (?foundMonth) {
              let canisterId = foundMonth.1;
              let monthly_leaderboard_canister = actor (canisterId) : actor {
                getMonthlyLeaderboardEntry : (seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth, clubId : FootballIds.ClubId, principalId : Text) -> async ?LeaderboardQueries.LeaderboardEntry;
              };

              let leaderboardEntry = await monthly_leaderboard_canister.getMonthlyLeaderboardEntry(seasonId, month, clubId, principalId);
              return leaderboardEntry;
            };
            case (null) {};
          };
        };
        case (null) {};
      };
      return null;
    };

    public func getSeasonLeaderboard(dto: LeaderboardQueries.GetSeasonLeaderboard) : async Result.Result<LeaderboardQueries.SeasonLeaderboard, Enums.Error> {
      // TODO
      return #err(#NotFound);
    };

    public func getSeasonLeaderboardEntry(principalId : Text, seasonId : FootballIds.SeasonId) : async ?LeaderboardQueries.LeaderboardEntry {

      let seasonEntryResult = Array.find(
        seasonLeaderboardCanisters,
        func(seasonEntry : (FootballIds.SeasonId, Ids.CanisterId)) : Bool {
          seasonEntry.0 == seasonId;
        },
      );

      switch (seasonEntryResult) {
        case (?foundSeason) {
          let canisterId = foundSeason.1;

          let season_leaderboard_canister = actor (canisterId) : actor {
            getSeasonLeaderboardEntry : (seasonId : FootballIds.SeasonId, principalId : Text) -> async ?LeaderboardQueries.LeaderboardEntry;
          };

          let leaderboardEntry = await season_leaderboard_canister.getSeasonLeaderboardEntry(seasonId, principalId);
          return leaderboardEntry;
        };
        case (null) {};
      };
      return null;
    };

    public func getMostValuableTeamLeaderboard(dto: LeaderboardQueries.GetMostValuableTeamLeaderboard) : async Result.Result<LeaderboardQueries.MostValuableTeamLeaderboard, Enums.Error> {
      // TODO
      return #err(#NotFound);
    };


    // TODO - ensure this is working correctly with our single canister structure

    public func calculateLeaderboards(seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber, month : BaseDefinitions.CalendarMonth, uniqueManagerCanisterIds : [Ids.CanisterId]) : async () {
      if (activeCanisterId == "") {
        activeCanisterId := await createLeaderboardCanister();
      };

      var leaderboard_canister = actor (activeCanisterId) : actor {
        getTotalLeaderboards : () -> async Nat;
        addLeaderboardChunk : (seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth, gameweek : FootballDefinitions.GameweekNumber, clubId : FootballIds.ClubId, entriesChunk : [AppTypes.LeaderboardEntry]) -> async ();
        prepareForWeeklyUpdate : (seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber) -> async ();
        prepareForMonthlyUpdate : (seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth, clubId : FootballIds.ClubId) -> async ();
        prepareForSeasonUpdate : (seasonId : FootballIds.SeasonId) -> async ();
        finaliseUpdate : (seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth, gameweek : FootballDefinitions.GameweekNumber) -> async ();
      };

      let totalLeaderboards = await leaderboard_canister.getTotalLeaderboards();

      if (totalLeaderboards >= MAX_LEADERBOARDS_PER_CANISTER) {
        activeCanisterId := await createLeaderboardCanister();
      };

      leaderboard_canister := actor (activeCanisterId) : actor {
        getTotalLeaderboards : () -> async Nat;
        addLeaderboardChunk : (seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth, gameweek : FootballDefinitions.GameweekNumber, clubId : FootballIds.ClubId, entriesChunk : [AppTypes.LeaderboardEntry]) -> async ();
        prepareForWeeklyUpdate : (seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber) -> async ();
        prepareForMonthlyUpdate : (seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth, clubId : FootballIds.ClubId) -> async ();
        prepareForSeasonUpdate : (seasonId : FootballIds.SeasonId) -> async ();
        finaliseUpdate : (seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth, gameweek : FootballDefinitions.GameweekNumber) -> async ();
      };

      //TODO: Need a way to separate out month as before we had the leaderboards in individual canisters but now we have them in a single canister
      /*
      if(month > 0){
        for(clubId in Iter.fromArray(clubIds)){
          await leaderboard_canister.prepareForMonthlyUpdate(seasonId, month, clubId);
        };
      } else {
        await leaderboard_canister.prepareForSeasonUpdate(seasonId);
      };
      */

      await leaderboard_canister.prepareForWeeklyUpdate(seasonId, gameweek);
      for (canisterId in Iter.fromArray(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getOrderedSnapshots : (seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber) -> async [AppTypes.FantasyTeamSnapshot];
        };

        let orderedSnapshots = await manager_canister.getOrderedSnapshots(seasonId, gameweek);

        let groupedByTeam = groupByTeam(orderedSnapshots);

        for (team in groupedByTeam.entries()) {
          let fantasyTeamSnapshots = team.1;

          let leaderboardEntries = Array.map<AppTypes.FantasyTeamSnapshot, AppTypes.LeaderboardEntry>(
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

      if (gameweek == 0 and month == 0) {
        addSeasonLeaderboardCanisterId(seasonId);
        return;
      };

      if (month == 0) {
        addWeeklyLeaderboardCanisterId(seasonId, gameweek);
        return;
      };

      addMonthlyLeaderboardCanisterId(seasonId, month);

    };

    private func addSeasonLeaderboardCanisterId(seasonId : FootballIds.SeasonId) {
      let seasonCanisterIdsBuffer = Buffer.fromArray<(FootballIds.SeasonId, Ids.CanisterId)>(seasonLeaderboardCanisters);
      seasonCanisterIdsBuffer.add(seasonId, activeCanisterId);
      seasonLeaderboardCanisters := Buffer.toArray(seasonCanisterIdsBuffer);
    };

    private func addWeeklyLeaderboardCanisterId(seasonId : FootballIds.SeasonId, gameweek : FootballDefinitions.GameweekNumber) {

      let weeklyLeaderboardCanisterBuffer = Buffer.fromArray<(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, Ids.CanisterId)])>([]);
      var seasonExists = false;

      for (canister in Iter.fromArray(weeklyLeaderboardCanisters)) {
        if (canister.0 == seasonId) {
          let gameweekBuffer = Buffer.fromArray<(FootballDefinitions.GameweekNumber, Ids.CanisterId)>([]);
          var gameweekFound = false;
          for (existingGameweek in Iter.fromArray(canister.1)) {
            if (existingGameweek.0 == gameweek) {
              gameweekBuffer.add(existingGameweek.0, activeCanisterId);
              gameweekFound := true;
            } else {
              gameweekBuffer.add(existingGameweek);
            };
          };

          if (not gameweekFound) {
            gameweekBuffer.add(gameweek, activeCanisterId);
          };
          weeklyLeaderboardCanisterBuffer.add((canister.0, Buffer.toArray(gameweekBuffer)));
          seasonExists := true;
        } else {
          weeklyLeaderboardCanisterBuffer.add(canister);
        };
      };

      if (not seasonExists) {
        weeklyLeaderboardCanisterBuffer.add(seasonId, [(gameweek, activeCanisterId)]);
      };

      weeklyLeaderboardCanisters := Buffer.toArray(weeklyLeaderboardCanisterBuffer);
    };

    private func addMonthlyLeaderboardCanisterId(seasonId : FootballIds.SeasonId, month : BaseDefinitions.CalendarMonth) {

      let monthCanisterIdsBuffer = Buffer.fromArray<(FootballIds.SeasonId, [(BaseDefinitions.CalendarMonth, Ids.CanisterId)])>(monthlyLeaderboardCanisters);
      monthCanisterIdsBuffer.add(seasonId, [(month, activeCanisterId)]);
      monthlyLeaderboardCanisters := Buffer.toArray(monthCanisterIdsBuffer);
    };

    private func groupByTeam(snapshots : [AppTypes.FantasyTeamSnapshot]) : TrieMap.TrieMap<FootballIds.ClubId, [AppTypes.FantasyTeamSnapshot]> {
      let groupedTeams : TrieMap.TrieMap<FootballIds.ClubId, [AppTypes.FantasyTeamSnapshot]> = TrieMap.TrieMap<FootballIds.ClubId, [AppTypes.FantasyTeamSnapshot]>(BaseUtilities.eqNat16, BaseUtilities.hashNat16);

      for (fantasyTeam in Iter.fromArray(snapshots)) {
        switch (fantasyTeam.favouriteClubId) {
          case (?foundClubId) {
            switch (groupedTeams.get(foundClubId)) {
              case null {
                groupedTeams.put(foundClubId, [fantasyTeam]);
              };
              case (?existingEntries) {
                let updatedEntries = Buffer.fromArray<AppTypes.FantasyTeamSnapshot>(existingEntries);
                updatedEntries.add(fantasyTeam);
                groupedTeams.put(foundClubId, Buffer.toArray(updatedEntries));
              };
            };
          };
          case (null) {

          };
        };
      };

      return groupedTeams;
    };

    private func createLeaderboardCanister() : async Text {
      Cycles.add<system>(50_000_000_000_000);
      let canister = await LeaderboardCanister._LeaderboardCanister();
      let IC : Management.Management = actor (CanisterIds.Default);
      let _ = await CanisterUtilities.updateCanister_(canister, ?Principal.fromText(CanisterIds.OPENFPL_BACKEND_CANISTER_ID), IC);

      let canister_principal = Principal.fromActor(canister);
      let canisterId = Principal.toText(canister_principal);

      if (canisterId == "") {
        return canisterId;
      };

      let uniqueCanisterIdBuffer = Buffer.fromArray<Ids.CanisterId>(uniqueLeaderboardCanisterIds);
      uniqueCanisterIdBuffer.add(canisterId);
      uniqueLeaderboardCanisterIds := Buffer.toArray(uniqueCanisterIdBuffer);

      return canisterId;
    };

    private func createLeaderboardEntry(principalId : Text, username : Text, points : Int16) : AppTypes.LeaderboardEntry {
      return {
        position = 0;
        positionText = "";
        username = username;
        principalId = principalId;
        points = points;
      };
    };

    public func getUniqueLeaderboardCanisterIds() : [Ids.CanisterId] {
      return uniqueLeaderboardCanisterIds;
    };

    public func getActiveRewardRates() : AppTypes.RewardRates {
      return rewardManager.getActiveRewardRates();
    };

    //Statble Storage

    public func getStableActiveRewardRates() : AppTypes.RewardRates {
      return rewardManager.getStableActiveRewardRates();
    };

    public func setStableActiveRewardRates(stable_active_reward_rates : AppTypes.RewardRates) {
      rewardManager.setStableActiveRewardRates(stable_active_reward_rates);
    };

    public func getStableHistoricRewardRates() : [AppTypes.RewardRates] {
      return rewardManager.getStableHistoricRewardRates();
    };

    public func setStableHistoricRewardRates(stable_historic_reward_rates : [AppTypes.RewardRates]) {
      rewardManager.setStableHistoricRewardRates(stable_historic_reward_rates);
    };

    public func getStableUniqueLeaderboardCanisterIds() : [Ids.CanisterId] {
      return uniqueLeaderboardCanisterIds;
    };

    public func setStableUniqueLeaderboardCanisterIds(stable_leaderboard_canister_ids : [Ids.CanisterId]) {
      uniqueLeaderboardCanisterIds := stable_leaderboard_canister_ids;
    };

    public func getStableWeeklyLeaderboardCanisterIds() : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, Ids.CanisterId)])] {
      return weeklyLeaderboardCanisters;
    };

    public func setStableWeeklyLeaderboardCanisterIds(leaderboard_canisters : [(FootballIds.SeasonId, [(FootballDefinitions.GameweekNumber, Ids.CanisterId)])]) {
      weeklyLeaderboardCanisters := leaderboard_canisters;
    };

    public func getStableMonthlyLeaderboardCanisterIds() : [(FootballIds.SeasonId, [(BaseDefinitions.CalendarMonth, Ids.CanisterId)])] {
      return monthlyLeaderboardCanisters;
    };

    public func setStableMonthlyLeaderboardCanisterIds(leaderboard_canisters : [(FootballIds.SeasonId, [(BaseDefinitions.CalendarMonth, Ids.CanisterId)])]) {
      monthlyLeaderboardCanisters := leaderboard_canisters;
    };

    public func getStableSeasonLeaderboardCanisterIds() : [(FootballIds.SeasonId, Ids.CanisterId)] {
      return seasonLeaderboardCanisters;
    };

    public func setStableSeasonLeaderboardCanisterIds(leaderboard_canisters : [(FootballIds.SeasonId, Ids.CanisterId)]) {
      seasonLeaderboardCanisters := leaderboard_canisters;
    };

    public func getStableTeamValueLeaderboards() : [(FootballIds.SeasonId, AppTypes.TeamValueLeaderboard)] {
      return rewardManager.getStableTeamValueLeaderboards();
    };

    public func getStableWeeklyAllTimeHighScores() : [AppTypes.HighScoreRecord] {
      return rewardManager.getStableWeeklyAllTimeHighScores();
    };

    public func getStableMonthlyAllTimeHighScores() : [AppTypes.HighScoreRecord] {
      return rewardManager.getStableMonthlyAllTimeHighScores();
    };

    public func getStableSeasonAllTimeHighScores() : [AppTypes.HighScoreRecord] {
      return rewardManager.getStableSeasonAllTimeHighScores();
    };

    public func setStableTeamValueLeaderboards(stable_team_value_leaderboards : [(FootballIds.SeasonId, AppTypes.TeamValueLeaderboard)]) {
      return rewardManager.setStableTeamValueLeaderboards(stable_team_value_leaderboards);
    };

    public func getStableSeasonRewards() : [AppTypes.SeasonRewards] {
      return rewardManager.getStableSeasonRewards();
    };

    public func setStableSeasonRewards(stable_season_rewards : [AppTypes.SeasonRewards]) {
      return rewardManager.setStableSeasonRewards(stable_season_rewards);
    };

    public func getStableMonthlyRewards() : [AppTypes.MonthlyRewards] {
      return rewardManager.getStableMonthlyRewards();
    };

    public func setStableMonthlyRewards(stable_monthly_rewards : [AppTypes.MonthlyRewards]) {
      return rewardManager.setStableMonthlyRewards(stable_monthly_rewards);
    };

    public func getStableWeeklyRewards() : [AppTypes.WeeklyRewards] {
      return rewardManager.getStableWeeklyRewards();
    };

    public func setStableWeeklyRewards(stable_weekly_rewards : [AppTypes.WeeklyRewards]) {
      return rewardManager.setStableWeeklyRewards(stable_weekly_rewards);
    };

    public func getStableMostValuableTeamRewards() : [AppTypes.RewardsList] {
      return rewardManager.getStableMostValuableTeamRewards();
    };

    public func setStableMostValuableTeamRewards(stable_most_valuable_team_rewards : [AppTypes.RewardsList]) {
      return rewardManager.setStableMostValuableTeamRewards(stable_most_valuable_team_rewards);
    };

    public func getStableHighestScoringPlayerRewards() : [AppTypes.RewardsList] {
      return rewardManager.getStableHighestScoringPlayerRewards();
    };

    public func setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards : [AppTypes.RewardsList]) {
      return rewardManager.setStableHighestScoringPlayerRewards(stable_highest_scoring_player_rewards);
    };

    public func setStableWeeklyAllTimeHighScores(stable_weekly_all_time_high_scores : [AppTypes.HighScoreRecord]) {
      return rewardManager.setStableWeeklyAllTimeHighScores(stable_weekly_all_time_high_scores);
    };

    public func setStableMonthlyAllTimeHighScores(stable_monthly_all_time_high_scores : [AppTypes.HighScoreRecord]) {
      return rewardManager.setStableMonthlyAllTimeHighScores(stable_monthly_all_time_high_scores);
    };

    public func setStableSeasonAllTimeHighScores(stable_season_all_time_high_scores : [AppTypes.HighScoreRecord]) {
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

    public func getStableActiveCanisterId() : Ids.CanisterId {
      return activeCanisterId;
    };

    public func setStableActiveCanisterId(stable_active_canister_id : Ids.CanisterId) {
      activeCanisterId := stable_active_canister_id;
    };

  };

};
