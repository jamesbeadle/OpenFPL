import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Int16 "mo:base/Int16";
import Int64 "mo:base/Int64";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat16 "mo:base/Nat16";
import Nat64 "mo:base/Nat64";
import Option "mo:base/Option";
import Order "mo:base/Order";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import TrieMap "mo:base/TrieMap";

import Account "../lib/Account";
import Constants "../utils/Constants";
import DTOs "../DTOs";
import Environment "../utils/Environment";
import RewardPercentages "../utils/RewardPercentages";
import SNSToken "../sns-wrappers/ledger";
import T "../types";
import Utilities "../utils/utilities";

module {

  public class Rewards() {

    private var teamValueLeaderboards : TrieMap.TrieMap<T.SeasonId, T.TeamValueLeaderboard> = TrieMap.TrieMap<T.SeasonId, T.TeamValueLeaderboard>(Utilities.eqNat16, Utilities.hashNat16);

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

    public func distributeWeeklyRewards(defaultAccount : Principal, weeklyRewardPool : Nat64, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO) : async () {

      let weeklyRewardAmount = weeklyRewardPool / 38;
      await mintToTreasury(weeklyRewardAmount, defaultAccount);

      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(weeklyLeaderboard.entries);

      let scaledPercentages = Utilities.scalePercentages(RewardPercentages.percentages, weeklyLeaderboard.totalEntries);

      while (not List.isNil(currentEntries)) {
        let (currentEntry, rest) = List.pop(currentEntries);
        currentEntries := rest;
        switch (currentEntry) {
          case (null) {};
          case (?foundEntry) {
            let (nextEntry, _) = List.pop(rest);
            switch (nextEntry) {
              case (null) {
                let payout = scaledPercentages[foundEntry.position - 1];
                payouts := List.push(payout, payouts);
              };
              case (?foundNextEntry) {
                if (foundEntry.points == foundNextEntry.points) {
                  let tiedEntries = Utilities.findTiedEntries(rest, foundEntry.points);
                  let startPosition = foundEntry.position;
                  let tiePayouts = Utilities.calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                  payouts := List.append(payouts, tiePayouts);

                  var skipEntries = rest;
                  label skipLoop while (not List.isNil(skipEntries)) {
                    let (skipEntry, nextRest) = List.pop(skipEntries);
                    skipEntries := nextRest;

                    switch (skipEntry) {
                      case (null) { break skipLoop };
                      case (?entry) {
                        if (entry.points != foundEntry.points) {
                          currentEntries := skipEntries;
                          break skipLoop;
                        };
                      };
                    };
                  };
                } else {
                  let payout = scaledPercentages[foundEntry.position - 1];
                  payouts := List.push(payout, payouts);
                };
              };
            };

          };
        };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);
      let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

      for (key in weeklyLeaderboard.entries.keys()) {
        let winner = weeklyLeaderboard.entries[key];
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * weeklyRewardAmount;
        await payReward(winner.principalId, prize, defaultAccount);
        rewardBuffer.add({
          principalId = winner.principalId;
          rewardType = #WeeklyLeaderboard;
          position = winner.position;
          amount = prize;
        });
      };

      let newWeeklyRewards : T.WeeklyRewards = {
        seasonId = weeklyLeaderboard.seasonId;
        gameweek = weeklyLeaderboard.gameweek;
        rewards = List.fromArray(Buffer.toArray(rewardBuffer));
      };

      weeklyRewards := List.append(weeklyRewards, List.make<T.WeeklyRewards>(newWeeklyRewards));
    };

    public func distributeMonthlyRewards(defaultAccount : Principal, rewardPool : T.RewardPool, monthlyLeaderboard : DTOs.ClubLeaderboardDTO, uniqueManagerCanisterIds : List.List<T.CanisterId>) : async () {
      let monthlyRewardAmount = rewardPool.monthlyLeaderboardPool / 10;
      await mintToTreasury(monthlyRewardAmount, defaultAccount);

      let clubManagersBuffer = Buffer.fromArray<T.PrincipalId>([]);
      var nonClubManagersCount : Nat = 0;

      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getClubManagers : (clubId : T.ClubId) -> async [T.PrincipalId];
          getNonClubManagers : (clubId : T.ClubId) -> async Nat;
        };

        let managers = await manager_canister.getClubManagers(monthlyLeaderboard.clubId);
        let nonClubCount = await manager_canister.getNonClubManagers(monthlyLeaderboard.clubId);

        clubManagersBuffer.append(Buffer.fromArray(managers));
        nonClubManagersCount := nonClubManagersCount + nonClubCount;
      };

      let clubManagers = Buffer.toArray(clubManagersBuffer);

      let clubManagerCount = clubManagers.size();
      let totalClubManagers = clubManagerCount + nonClubManagersCount;

      let clubShare = clubManagerCount / totalClubManagers;

      let clubManagerMonthlyRewardAmount = Nat64.toNat(monthlyRewardAmount) * clubShare;

      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(monthlyLeaderboard.entries);

      let scaledPercentages = Utilities.scalePercentages(RewardPercentages.percentages, monthlyLeaderboard.totalEntries);

      while (not List.isNil(currentEntries)) {
        let (currentEntry, rest) = List.pop(currentEntries);
        currentEntries := rest;
        switch (currentEntry) {
          case (null) {};
          case (?foundEntry) {
            let (nextEntry, _) = List.pop(rest);
            switch (nextEntry) {
              case (null) {
                let payout = scaledPercentages[foundEntry.position - 1];
                payouts := List.push(payout, payouts);
              };
              case (?foundNextEntry) {
                if (foundEntry.points == foundNextEntry.points) {
                  let tiedEntries = Utilities.findTiedEntries(rest, foundEntry.points);
                  let startPosition = foundEntry.position;
                  let tiePayouts = Utilities.calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                  payouts := List.append(payouts, tiePayouts);

                  var skipEntries = rest;
                  label skipLoop while (not List.isNil(skipEntries)) {
                    let (skipEntry, nextRest) = List.pop(skipEntries);
                    skipEntries := nextRest;

                    switch (skipEntry) {
                      case (null) { break skipLoop };
                      case (?entry) {
                        if (entry.points != foundEntry.points) {
                          currentEntries := skipEntries;
                          break skipLoop;
                        };
                      };
                    };
                  };
                } else {
                  let payout = scaledPercentages[foundEntry.position - 1];
                  payouts := List.push(payout, payouts);
                };
              };
            };

          };
        };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);
      let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

      for (key in monthlyLeaderboard.entries.keys()) {
        let winner = monthlyLeaderboard.entries[key];
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * Nat64.fromNat(clubManagerMonthlyRewardAmount);
        await payReward(winner.principalId, prize, defaultAccount);
        rewardBuffer.add({
          principalId = winner.principalId;
          rewardType = #MonthlyLeaderboard;
          position = winner.position;
          amount = prize;
        });
      };

      let newMonthlyRewards : T.MonthlyRewards = {
        seasonId = monthlyLeaderboard.seasonId;
        month = monthlyLeaderboard.month;
        clubId = monthlyLeaderboard.clubId;
        rewards = List.fromArray(Buffer.toArray(rewardBuffer));
      };
      monthlyRewards := List.append(monthlyRewards, List.make<T.MonthlyRewards>(newMonthlyRewards));
    };

    public func distributeSeasonRewards(defaultAccount : Principal, seasonRewardPool : Nat64, seasonLeaderboard : DTOs.SeasonLeaderboardDTO) : async () {

      await mintToTreasury(seasonRewardPool, defaultAccount);

      var payouts = List.nil<Float>();
      var currentEntries = List.fromArray(seasonLeaderboard.entries);

      let scaledPercentages = Utilities.scalePercentages(RewardPercentages.percentages, seasonLeaderboard.totalEntries);
      
      while (not List.isNil(currentEntries)) {
        let (currentEntry, rest) = List.pop(currentEntries);
        currentEntries := rest;
        switch (currentEntry) {
          case (null) {};
          case (?foundEntry) {
            let (nextEntry, _) = List.pop(rest);
            switch (nextEntry) {
              case (null) {
                let payout = scaledPercentages[foundEntry.position - 1];
                payouts := List.push(payout, payouts);
              };
              case (?foundNextEntry) {
                if (foundEntry.points == foundNextEntry.points) {
                  let tiedEntries = Utilities.findTiedEntries(rest, foundEntry.points);
                  let startPosition = foundEntry.position;
                  let tiePayouts = Utilities.calculateTiePayouts(tiedEntries, scaledPercentages, startPosition);
                  payouts := List.append(payouts, tiePayouts);

                  var skipEntries = rest;
                  label skipLoop while (not List.isNil(skipEntries)) {
                    let (skipEntry, nextRest) = List.pop(skipEntries);
                    skipEntries := nextRest;

                    switch (skipEntry) {
                      case (null) { break skipLoop };
                      case (?entry) {
                        if (entry.points != foundEntry.points) {
                          currentEntries := skipEntries;
                          break skipLoop;
                        };
                      };
                    };
                  };
                } else {
                  let payout = scaledPercentages[foundEntry.position - 1];
                  payouts := List.push(payout, payouts);
                };
              };
            };

          };
        };
      };

      payouts := List.reverse(payouts);
      let payoutsArray = List.toArray(payouts);
      let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

      for (key in seasonLeaderboard.entries.keys()) {
        let winner = seasonLeaderboard.entries[key];
        let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * seasonRewardPool;
        await payReward(winner.principalId, prize, defaultAccount);
        rewardBuffer.add({
          principalId = winner.principalId;
          rewardType = #WeeklyLeaderboard;
          position = winner.position;
          amount = prize;
        });
      };

      let newSeasonRewards : T.SeasonRewards = {
        seasonId = seasonLeaderboard.seasonId;
        rewards = List.fromArray(Buffer.toArray(rewardBuffer));
      };
      seasonRewards := List.append(seasonRewards, List.make<T.SeasonRewards>(newSeasonRewards));
    };

    public func distributeMostValuableTeamRewards(defaultAccount : Principal, mostValuableTeamPool : Nat64, players : [DTOs.PlayerDTO], currentSeason : T.SeasonId, uniqueManagerCanisterIds : List.List<T.CanisterId>) : async () {

      await mintToTreasury(mostValuableTeamPool, defaultAccount);

      let gameweek38Snapshots = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
      let mostValuableTeamsBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
      for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
        let manager_canister = actor (canisterId) : actor {
          getGameweek38Snapshots : () -> async [T.FantasyTeamSnapshot];
          getMostValuableTeams : T.SeasonId -> async [T.FantasyTeamSnapshot];
        };

        let gameweek38Snapshots = await manager_canister.getGameweek38Snapshots();

        let mostValuableTeams = await manager_canister.getMostValuableTeams(currentSeason);
        mostValuableTeamsBuffer.append(Buffer.fromArray(mostValuableTeams));
      };

      let allFinalGameweekSnapshots = Buffer.toArray(gameweek38Snapshots);

      var teamValues : TrieMap.TrieMap<T.PrincipalId, Nat16> = TrieMap.TrieMap<T.PrincipalId, Nat16>(Text.equal, Text.hash);

      for (snapshot in Iter.fromArray(allFinalGameweekSnapshots)) {
        let allPlayers = Array.filter<DTOs.PlayerDTO>(
          players,
          func(player : DTOs.PlayerDTO) : Bool {
            let playerId = player.id;
            let isPlayerIdInNewTeam = Array.find(
              snapshot.playerIds,
              func(id : Nat16) : Bool {
                return id == playerId;
              },
            );
            return Option.isSome(isPlayerIdInNewTeam);
          },
        );

        let allPlayerValues = Array.map<DTOs.PlayerDTO, Nat16>(allPlayers, func(player : DTOs.PlayerDTO) : Nat16 { return player.valueQuarterMillions });
        let totalTeamValue = Array.foldLeft<Nat16, Nat16>(allPlayerValues, 0, func(sumSoFar, x) = sumSoFar + x);
        teamValues.put(snapshot.principalId, totalTeamValue);
      };

      let teamValuesArray : [(T.PrincipalId, Nat16)] = Iter.toArray(teamValues.entries());

      let compare = func(a : (T.PrincipalId, Nat16), b : (T.PrincipalId, Nat16)) : Order.Order {
        if (a.1 > b.1) { return #greater };
        if (a.1 < b.1) { return #less };
        return #equal;
      };

      let sortedTeamValuesArray = Array.sort(teamValuesArray, compare);

      var leaderboardEntries = Array.mapEntries<(T.PrincipalId, Nat16), T.LeaderboardEntry>(
        sortedTeamValuesArray,
        func(team, index) : T.LeaderboardEntry {
          return {
            principalId = team.0;
            position = index + 1;
            points = Int16.fromNat16(team.1);
            username = "";
            positionText = "";
          };
        },
      );

      var totalRewardEntries = 100;
      if (Array.size(leaderboardEntries) < 100) {
        totalRewardEntries := Array.size(leaderboardEntries);
      };
      var rewardEntries = List.take(List.fromArray(leaderboardEntries), totalRewardEntries);

      var rewardEntriesBuffer = Buffer.fromArray<T.LeaderboardEntry>(List.toArray(rewardEntries));

      if (totalRewardEntries == 100) {
        let lastEntry = List.toArray(rewardEntries)[99];
        let tiedEntries = Array.filter<T.LeaderboardEntry>(
          leaderboardEntries,
          func(entry) : Bool {
            entry.points == lastEntry.points and entry.position > 100
          },
        );
        rewardEntriesBuffer.append(Buffer.fromArray(tiedEntries));
      };
      rewardEntries := List.fromArray(Buffer.toArray(rewardEntriesBuffer));

      var scaledPercentages = RewardPercentages.percentages;

      if (List.size(rewardEntries) < 100) {
        scaledPercentages := Utilities.scalePercentages(RewardPercentages.percentages, List.size(rewardEntries));
      };

      let rewardEntriesArray = List.toArray(rewardEntries);

      let teamValueLeaderboard : T.TeamValueLeaderboard = {
        seasonId = currentSeason;
        entries = rewardEntries;
        totalEntries = List.size(rewardEntries);
      };

      teamValueLeaderboards.put(currentSeason, teamValueLeaderboard);
      let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

      for (index in Iter.range(0, Array.size(rewardEntriesArray) - 1)) {
        let entry = rewardEntriesArray[index];
        let payoutPercentage = scaledPercentages[entry.position - 1];

        let prize = Float.fromInt64(Int64.fromNat64(mostValuableTeamPool)) * payoutPercentage;
        await payReward(entry.principalId, Int64.toNat64(Float.toInt64(prize)), defaultAccount);
        rewardBuffer.add({
          principalId = entry.principalId;
          rewardType = #MostValuableTeam;
          position = entry.position;
          amount = Int64.toNat64(Float.toInt64(prize));
        });
      };

      let newMVTRewards : T.SeasonRewards = {
        seasonId = currentSeason;
        rewards = List.fromArray(Buffer.toArray(rewardBuffer));
      };
      mostValuableTeamRewards := List.append(mostValuableTeamRewards, List.make<T.SeasonRewards>(newMVTRewards));
    };

    public func distributeHighestScoringPlayerRewards(defaultAccount : Principal, seasonId : T.SeasonId, gameweek : T.GameweekNumber, highestScoringPlayerRewardPool : Nat64, fixtures : List.List<DTOs.FixtureDTO>, uniqueManagerCanisterIds : List.List<T.CanisterId>) : async () {

      await mintToTreasury(highestScoringPlayerRewardPool, defaultAccount);

      let highestScoringPlayerIdBuffer = Buffer.fromArray<T.PlayerId>([]);

      for (fixture in Iter.fromList(fixtures)) {
        if (fixture.highestScoringPlayerId > 0) {
          highestScoringPlayerIdBuffer.add(fixture.highestScoringPlayerId);
        };
      };

      let highestScoringPlayerIds = Buffer.toArray(highestScoringPlayerIdBuffer);

      let gameweekRewardAmount = highestScoringPlayerRewardPool / 38;

      for (highestScoringPlayerId in Iter.fromArray(highestScoringPlayerIds)) {

        let managersWithPlayerBuffer = Buffer.fromArray<T.PrincipalId>([]);
        for (canisterIds in Iter.fromList(uniqueManagerCanisterIds)) {
          let manager_canister = actor (canisterIds) : actor {
            getManagersWithPlayer : (playerId : T.PlayerId) -> async [T.PrincipalId];
          };

          let managerIds = await manager_canister.getManagersWithPlayer(highestScoringPlayerId);

          managersWithPlayerBuffer.append(Buffer.fromArray(managerIds));
        };

        let prize = Nat64.fromNat(Nat64.toNat(gameweekRewardAmount) / managersWithPlayerBuffer.size());
        let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

        let managersWithPlayers = Buffer.toArray(managersWithPlayerBuffer);

        for (managerPrincipalId in Iter.fromArray(managersWithPlayers)) {
          await payReward(managerPrincipalId, prize, defaultAccount);
          rewardBuffer.add({
            principalId = managerPrincipalId;
            rewardType = #WeeklyLeaderboard;
            position = 0;
            amount = prize;
          });

          let ledger : SNSToken.Interface = actor (Environment.SNS_LEDGER_CANISTER_ID);
      
          let _ = await ledger.icrc1_transfer ({
            memo = ?Text.encodeUtf8("0");
            from_subaccount = null;
            to = { owner = defaultAccount; subaccount = ?Account.principalToSubaccount(Principal.fromText(managerPrincipalId)) };
            amount = Nat64.toNat(prize);
            fee = ?Nat64.toNat(Constants.FPL_TRANSACTION_FEE);
            created_at_time = ?Nat64.fromNat(Int.abs(Time.now()))
          });
          
        };

        let newHSPRewards : T.WeeklyRewards = {
          seasonId = seasonId;
          gameweek = gameweek;
          rewards = List.fromArray(Buffer.toArray(rewardBuffer));
        };
        highScoringPlayerRewards := List.append(highScoringPlayerRewards, List.make<T.SeasonRewards>(newHSPRewards));
      };
    };

    public func distributeWeeklyATHScoreRewards(defaultAccount : Principal, weeklyRewardPool : Nat64, weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO) : async () {
      let weeklyATHReward = weeklyRewardPool / 38;
      await mintToTreasury(weeklyATHReward, defaultAccount);

      let maybeLastHighScore = List.last<T.HighScoreRecord>(weeklyAllTimeHighScores);
      var highestWeeklyScore : Int16 = 0;
      switch (maybeLastHighScore) {
        case (null) {
          highestWeeklyScore := 0;
        };
        case (?lastHighScore) {
          highestWeeklyScore := lastHighScore.points;
        };
      };

      let leaderboardEntries = weeklyLeaderboard.entries;
      let topScore : Int16 = if (leaderboardEntries.size() > 0) {
        leaderboardEntries[0].points;
      } else {
        0;
      };

      if (topScore > highestWeeklyScore) {
        weeklyAllTimeHighScores := List.append(weeklyAllTimeHighScores, List.make({ recordType = #WeeklyHighScore; points = topScore; createDate = Time.now() }));
        await payReward(leaderboardEntries[0].principalId, weeklyRewardPool, defaultAccount);
        weeklyATHPrizePool := 0;
      };

      var tiedWinners = Array.filter<T.LeaderboardEntry>(
        leaderboardEntries,
        func(entry) : Bool { entry.points == topScore },
      );

      if (tiedWinners.size() > 1 and topScore > highestWeeklyScore) {
        let payoutPerWinner = weeklyRewardPool / Nat64.fromNat(tiedWinners.size());
        for (winner in Iter.fromArray(tiedWinners)) {
          await payReward(winner.principalId, payoutPerWinner, defaultAccount);
          weeklyAllTimeHighScores := List.append(weeklyAllTimeHighScores, List.make({ recordType = #WeeklyHighScore; points = winner.points; createDate = Time.now() }));
          weeklyATHPrizePool := 0;
        };
      } else {
        weeklyATHPrizePool := weeklyATHPrizePool + weeklyATHReward;
      };
    };

    public func distributeMonthlyATHScoreRewards(defaultAccount : Principal, monthlyRewardPool : Nat64, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO]) : async () {
      let monthlyATHReward = monthlyRewardPool / 10;
      await mintToTreasury(monthlyATHReward, defaultAccount);

      let maybeLastHighScore = List.last<T.HighScoreRecord>(monthlyAllTimeHighScores);
      var highestMonthlyScore : Int16 = 0;
      switch (maybeLastHighScore) {
        case (null) {
          highestMonthlyScore := 0;
        };
        case (?lastHighScore) {
          highestMonthlyScore := lastHighScore.points;
        };
      };

      var winnersBuffer = Buffer.fromArray<T.LeaderboardEntry>([]);
      var newRecordSet = false;

      var winners = Buffer.toArray(winnersBuffer);
      for (monthlyLeaderboard in Iter.fromArray(monthlyLeaderboards)) {
        let leaderboardEntries = monthlyLeaderboard.entries;
        if (leaderboardEntries.size() > 0) {
          let topScore = leaderboardEntries[0].points;
          if (topScore > highestMonthlyScore) {
            highestMonthlyScore := topScore;
            winnersBuffer.clear();
            winnersBuffer.add(leaderboardEntries[0]);
            newRecordSet := true;

            winners := Buffer.toArray(winnersBuffer);
            for (entry in leaderboardEntries.vals()) {
              if (entry.points == topScore and entry.principalId != winners[0].principalId) {
                winnersBuffer.add(entry);
              };
            };
          };
        };
      };

      winners := Buffer.toArray(winnersBuffer);
      if (newRecordSet) {
        let totalPayout = monthlyATHReward * Nat64.fromNat(winners.size());
        for (winner in Iter.fromArray(winners)) {
          await payReward(winner.principalId, totalPayout / Nat64.fromNat(winners.size()), defaultAccount);
          monthlyAllTimeHighScores := List.append(monthlyAllTimeHighScores, List.make({ recordType = #MonthlyHighScore; points = winner.points; createDate = Time.now() }));
          monthlyATHPrizePool := 0;
        };
      } else {
        monthlyATHPrizePool := monthlyATHPrizePool + monthlyATHReward;
      };
    };

    public func distributeSeasonATHScoreRewards(defaultAccount : Principal, seasonRewardPool : Nat64, seasonLeaderboard : DTOs.SeasonLeaderboardDTO) : async () {
      await mintToTreasury(seasonRewardPool, defaultAccount);
      let maybeLastHighScore = List.last<T.HighScoreRecord>(seasonAllTimeHighScores);
      var highestSeasonScore : Int16 = 0;
      switch (maybeLastHighScore) {
        case (null) {
          highestSeasonScore := 0;
        };
        case (?lastHighScore) {
          highestSeasonScore := lastHighScore.points;
        };
      };

      let leaderboardEntries = seasonLeaderboard.entries;
      let topScore : Int16 = if (leaderboardEntries.size() > 0) {
        leaderboardEntries[0].points;
      } else {
        0;
      };

      if (topScore > highestSeasonScore) {
        seasonAllTimeHighScores := List.append(seasonAllTimeHighScores, List.make({ recordType = #SeasonHighScore; points = topScore; createDate = Time.now() }));
        await payReward(leaderboardEntries[0].principalId, seasonRewardPool, defaultAccount);
        seasonATHPrizePool := 0;
      };

      var tiedWinners = Array.filter<T.LeaderboardEntry>(
        leaderboardEntries,
        func(entry) : Bool { entry.points == topScore },
      );

      if (tiedWinners.size() > 1 and topScore > highestSeasonScore) {
        let payoutPerWinner = seasonRewardPool / Nat64.fromNat(tiedWinners.size());
        for (winner in Iter.fromArray(tiedWinners)) {
          await payReward(winner.principalId, payoutPerWinner, defaultAccount);
          seasonAllTimeHighScores := List.append(seasonAllTimeHighScores, List.make({ recordType = #SeasonHighScore; points = winner.points; createDate = Time.now() }));
          seasonATHPrizePool := 0;
        };
      } else {
        weeklyATHPrizePool := weeklyATHPrizePool + seasonRewardPool;
      };
    };

    private func payReward(principalId : T.PrincipalId, fpl : Nat64, defaultAccount: Principal) : async () {
      let ledger : SNSToken.Interface = actor (Environment.SNS_LEDGER_CANISTER_ID);
      
      let _ = await ledger.icrc1_transfer ({
        memo = ?Text.encodeUtf8("0");
        from_subaccount = ?Account.principalToSubaccount(Principal.fromText(Environment.SNS_LEDGER_CANISTER_ID));
        to = { owner = defaultAccount; subaccount = ?Account.principalToSubaccount(Principal.fromText(principalId)) };
        amount = Nat64.toNat(fpl);
        fee = ?Nat64.toNat(Constants.FPL_TRANSACTION_FEE);
        created_at_time = ?Nat64.fromNat(Int.abs(Time.now()))
      });
    };

    private func mintToTreasury(fpl : Nat64, defaultAccount: Principal) : async () {
      let ledger : SNSToken.Interface = actor (Environment.SNS_LEDGER_CANISTER_ID);
      let _ = await ledger.icrc1_transfer({
        memo = ?Text.encodeUtf8("0");
        from_subaccount = null;
        to = { owner = defaultAccount; subaccount = ?Account.principalToSubaccount(Principal.fromText(Environment.SNS_LEDGER_CANISTER_ID)) };
        amount = Nat64.toNat(fpl);
        fee = ?Nat64.toNat(Constants.FPL_TRANSACTION_FEE);
        created_at_time = ?Nat64.fromNat(Int.abs(Time.now()))
      });
    };

    public func getStableTeamValueLeaderboards() : [(T.SeasonId, T.TeamValueLeaderboard)] {
      return Iter.toArray(teamValueLeaderboards.entries());
    };

    public func setStableTeamValueLeaderboards(stable_team_value_leaderboards : [(T.SeasonId, T.TeamValueLeaderboard)]) {
      teamValueLeaderboards := TrieMap.fromEntries<T.SeasonId, T.TeamValueLeaderboard>(
        Iter.fromArray(stable_team_value_leaderboards),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    };

    public func getStableSeasonRewards() : [T.SeasonRewards] {
      return List.toArray(seasonRewards);
    };

    public func setStableSeasonRewards(stable_season_rewards : [T.SeasonRewards]) {
      seasonRewards := List.fromArray(stable_season_rewards);
    };

    public func getStableMonthlyRewards() : [T.MonthlyRewards] {
      return List.toArray(monthlyRewards);
    };

    public func setStableMonthlyRewards(stable_monthly_rewards : [T.MonthlyRewards]) {
      seasonRewards := List.fromArray(stable_monthly_rewards);
    };

    public func getStableWeeklyRewards() : [T.WeeklyRewards] {
      return List.toArray(weeklyRewards);
    };

    public func setStableWeeklyRewards(stable_weekly_rewards : [T.WeeklyRewards]) {
      seasonRewards := List.fromArray(stable_weekly_rewards);
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

    public func getStableWeeklyATHScores() : [T.HighScoreRecord] {
      return List.toArray(weeklyAllTimeHighScores);
    };

    public func setStableWeeklyATHScores(stable_weekly_ath_scores : [T.HighScoreRecord]) {
      weeklyAllTimeHighScores := List.fromArray(stable_weekly_ath_scores);
    };

    public func getStableMonthlyATHScores() : [T.HighScoreRecord] {
      return List.toArray(monthlyAllTimeHighScores);
    };

    public func setStableMonthlyATHScores(stable_monthly_ath_scores : [T.HighScoreRecord]) {
      monthlyAllTimeHighScores := List.fromArray(stable_monthly_ath_scores);
    };

    public func getStableSeasonATHScores() : [T.HighScoreRecord] {
      return List.toArray(seasonAllTimeHighScores);
    };

    public func setStableSeasonATHScores(stable_season_ath_scores : [T.HighScoreRecord]) {
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

    public func getSeasonATHPrizePool() : Nat64 {
      return seasonATHPrizePool;
    };

    public func setSeasonATHPrizePool(stable_season_ath_prize_pool : Nat64) {
      seasonATHPrizePool := stable_season_ath_prize_pool;
    };
  };
};
