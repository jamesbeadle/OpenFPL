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
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Result "mo:base/Result";

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

    private var seasonGameweekCount: Nat8 = 0;

    public func getRewardPool(seasonId: FootballTypes.SeasonId) : ?T.RewardPool {
        return rewardPools.get(seasonId);
    };

    /*
    public func distributeWeeklyRewards(weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO) : async () {
      
      let rewardPool = rewardPools.get(weeklyLeaderboard.seasonId);
      switch(rewardPool){
        case (?foundRewardPool){
          let weeklyRewardAmount = Nat64.div(foundRewardPool.weeklyLeaderboardPool, Nat64.fromNat(Nat8.toNat(seasonGameweekCount)));

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
            //await payReward(winner.principalId, prize);
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
        case (null){}
      };
    };
    */

    public func distributeMonthlyRewards(seasonId: FootballTypes.SeasonId, monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO], uniqueManagerCanisterIds : List.List<Base.CanisterId>) : async () {
      
      //TODO (PAYOUT)
      /*
      let rewardPool = rewardPools.get(seasonId);
      switch(rewardPool){
        case (?foundRewardPool){
          let monthlyRewardAmount = Nat64.div(foundRewardPool.monthlyLeaderboardPool, seasonMonthCount);

          let clubManagersBuffer = Buffer.fromArray<Base.PrincipalId>([]);
          var nonClubManagersCount : Nat = 0;

          for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
            let manager_canister = actor (canisterId) : actor {
              getClubManagers : (leagueId: T.FootballLeagueId, clubId : T.ClubId) -> async [Base.PrincipalId];
              getNonClubManagers : (leagueId: T.FootballLeagueId, clubId : T.ClubId) -> async Nat;
            };

            let managers = await manager_canister.getClubManagers(monthlyLeaderboard.clubId);
            let nonClubCount = await manager_canister.getNonClubManagers(monthlyLeaderboard.clubId);

            clubManagersBuffer.append(Buffer.fromArray(managers));
            nonClubManagersCount := nonClubManagersCount + nonClubCount;
          };

          let clubManagers = Buffer.toArray(clubManagersBuffer);

          let clubManagerCount = clubManagers.size();
          let totalClubManagers = clubManagerCount + nonClubManagersCount;

          let clubShare = Nat.div(clubManagerCount, totalClubManagers);

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
            await payReward(winner.principalId, prize);
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
        case (null){};
      };
      */
    };

    /*
    public func distributeSeasonRewards(seasonLeaderboard : DTOs.SeasonLeaderboardDTO) : async () {
      
      let rewardPool = rewardPools.get(seasonLeaderboard.seasonId);
      switch(rewardPool){
        case (?foundRewardPool){
          var payouts = List.nil<Float>();
          var currentEntries = List.fromArray(seasonLeaderboard.entries);

          let scaledPercentages = await Utilities.scalePercentages(RewardPercentages.percentages, seasonLeaderboard.totalEntries);
          
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
            let prize = Int64.toNat64(Float.toInt64(payoutsArray[key])) * foundRewardPool.seasonLeaderboardPool;
            //await payReward(winner.principalId, prize);
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
        case (null) {};
      };
    };

    public func distributeMostValuableTeamRewards(players : [DTOs.PlayerDTO], currentSeason : FootballTypes.SeasonId, uniqueManagerCanisterIds : List.List<Base.CanisterId>) : async () {

      let rewardPool = rewardPools.get(currentSeason);
      switch(rewardPool){
        case (?foundRewardPool){
          let mostValuableTeamPool = foundRewardPool.mostValuableTeamPool;
          var finalGameweekSnapshotBuffers = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
          let mostValuableTeamsBuffer = Buffer.fromArray<T.FantasyTeamSnapshot>([]);
          for (canisterId in Iter.fromList(uniqueManagerCanisterIds)) {
            let manager_canister = actor (canisterId) : actor {
              getFinalGameweekSnapshots : (seasonId : FootballTypes.SeasonId) -> async [T.FantasyTeamSnapshot];
              getMostValuableTeams : (seasonId : FootballTypes.SeasonId) -> async [T.FantasyTeamSnapshot];
            };

            let snapshots = await manager_canister.getFinalGameweekSnapshots(currentSeason);
            finalGameweekSnapshotBuffers.append(Buffer.fromArray(snapshots));

            let mostValuableTeams = await manager_canister.getMostValuableTeams(currentSeason);
            mostValuableTeamsBuffer.append(Buffer.fromArray(mostValuableTeams));
          };

          let allFinalGameweekSnapshots = Buffer.toArray(finalGameweekSnapshotBuffers);

          var teamValues : TrieMap.TrieMap<Base.PrincipalId, Nat16> = TrieMap.TrieMap<Base.PrincipalId, Nat16>(Text.equal, Text.hash);

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

          let teamValuesArray : [(Base.PrincipalId, Nat16)] = Iter.toArray(teamValues.entries());

          let compare = func(a : (Base.PrincipalId, Nat16), b : (Base.PrincipalId, Nat16)) : Order.Order {
            if (a.1 > b.1) { return #greater };
            if (a.1 < b.1) { return #less };
            return #equal;
          };

          let sortedTeamValuesArray = Array.sort(teamValuesArray, compare);

          var leaderboardEntries = Array.mapEntries<(Base.PrincipalId, Nat16), T.LeaderboardEntry>(
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
            scaledPercentages := await Utilities.scalePercentages(RewardPercentages.percentages, List.size(rewardEntries));
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
            //await payReward(entry.principalId, Int64.toNat64(Float.toInt64(prize)));
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
        case (null) {};
      };
    };

    public func distributeHighestScoringPlayerRewards(seasonId : FootballTypes.SeasonId, gameweek : FootballTypes.GameweekNumber, fixtures : List.List<DTOs.FixtureDTO>, uniqueManagerCanisterIds : List.List<Base.CanisterId>) : async () {
      let rewardPool = rewardPools.get(seasonId);
      switch(rewardPool){
        case (?foundRewardPool){
          let highestScoringPlayerRewardPool = foundRewardPool.highestScoringMatchPlayerPool;
          let highestScoringPlayerIdBuffer = Buffer.fromArray<FootballTypes.PlayerId>([]);

          for (fixture in Iter.fromList(fixtures)) {
            if (fixture.highestScoringPlayerId > 0) {
              highestScoringPlayerIdBuffer.add(fixture.highestScoringPlayerId);
            };
          };

          let highestScoringPlayerIds = Buffer.toArray(highestScoringPlayerIdBuffer);

          let gameweekRewardAmount = Nat64.div(highestScoringPlayerRewardPool, Nat64.fromNat(Nat8.toNat(seasonGameweekCount))
          );

          for (highestScoringPlayerId in Iter.fromArray(highestScoringPlayerIds)) {

            let managersWithPlayerBuffer = Buffer.fromArray<Base.PrincipalId>([]);
            for (canisterIds in Iter.fromList(uniqueManagerCanisterIds)) {
              let manager_canister = actor (canisterIds) : actor {
                getManagersWithPlayer : (playerId : FootballTypes.PlayerId) -> async [Base.PrincipalId];
              };

              let managerIds = await manager_canister.getManagersWithPlayer(highestScoringPlayerId);

              managersWithPlayerBuffer.append(Buffer.fromArray(managerIds));
            };

            let prize = Nat64.div(gameweekRewardAmount, Nat64.fromNat(managersWithPlayerBuffer.size()));
            let rewardBuffer = Buffer.fromArray<T.RewardEntry>([]);

            let managersWithPlayers = Buffer.toArray(managersWithPlayerBuffer);

            for (managerPrincipalId in Iter.fromArray(managersWithPlayers)) {
              //await payReward(managerPrincipalId, prize);
              rewardBuffer.add({
                principalId = managerPrincipalId;
                rewardType = #WeeklyLeaderboard;
                position = 0;
                amount = prize;
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
        case (null) {};
      };
    };

    public func distributeWeeklyATHScoreRewards(weeklyLeaderboard : DTOs.WeeklyLeaderboardDTO) : async () {
      let rewardPool = rewardPools.get(weeklyLeaderboard.seasonId);
      switch(rewardPool){
        case (?foundRewardPool){


          let weeklyRewardPool = foundRewardPool.allTimeWeeklyHighScorePool;
          let weeklyATHReward = Nat64.div(weeklyRewardPool, Nat64.fromNat(Nat8.toNat(seasonGameweekCount)));

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
            //await payReward(leaderboardEntries[0].principalId, weeklyRewardPool);
            weeklyATHPrizePool := 0;
          };

          var tiedWinners = Array.filter<T.LeaderboardEntry>(
            leaderboardEntries,
            func(entry) : Bool { entry.points == topScore },
          );

          if (tiedWinners.size() > 1 and topScore > highestWeeklyScore) {
            let payoutPerWinner = Nat64.div(weeklyRewardPool, Nat64.fromNat(tiedWinners.size()));
            for (winner in Iter.fromArray(tiedWinners)) {
              //await payReward(winner.principalId, payoutPerWinner);
              weeklyAllTimeHighScores := List.append(weeklyAllTimeHighScores, List.make({ recordType = #WeeklyHighScore; points = winner.points; createDate = Time.now() }));
              weeklyATHPrizePool := 0;
            };
          } else {
            weeklyATHPrizePool := weeklyATHPrizePool + weeklyATHReward;
          };
        };
        case null {}
      };
    };
    
    public func distributeMonthlyATHScoreRewards(seasonId: FootballTypes.SeasonId , monthlyLeaderboards : [DTOs.MonthlyLeaderboardDTO]) : async () {
      
      let rewardPool = rewardPools.get(seasonId);
      
      switch(rewardPool){
        case (?foundRewardPool){
          let monthlyATHReward = Nat64.div(foundRewardPool.allTimeMonthlyHighScorePool, Nat64.fromNat(Nat8.toNat(seasonMonthCount)));
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
              //await payReward(winner.principalId, Nat64.div(totalPayout, Nat64.fromNat(winners.size())));
              monthlyAllTimeHighScores := List.append(monthlyAllTimeHighScores, List.make({ recordType = #MonthlyHighScore; points = winner.points; createDate = Time.now() }));
              monthlyATHPrizePool := 0;
            };
          } else {
            monthlyATHPrizePool := monthlyATHPrizePool + monthlyATHReward;
          };
        };
        case (null){};
      };      
    };


    public func distributeSeasonATHScoreRewards(seasonLeaderboard : DTOs.SeasonLeaderboardDTO) : async () {

      let rewardPool = rewardPools.get(seasonLeaderboard.seasonId);
      
      switch(rewardPool){
        case (?foundRewardPool){

          let seasonRewardPool = foundRewardPool.allTimeSeasonHighScorePool;
          
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
            //await payReward(leaderboardEntries[0].principalId, seasonRewardPool);
            seasonATHPrizePool := 0;
          };

          var tiedWinners = Array.filter<T.LeaderboardEntry>(
            leaderboardEntries,
            func(entry) : Bool { entry.points == topScore },
          );

          if (tiedWinners.size() > 1 and topScore > highestSeasonScore) {
            let payoutPerWinner = Nat64.div(seasonRewardPool, Nat64.fromNat(tiedWinners.size()));
            for (winner in Iter.fromArray(tiedWinners)) {
              //await payReward(winner.principalId, payoutPerWinner);
              seasonAllTimeHighScores := List.append(seasonAllTimeHighScores, List.make({ recordType = #SeasonHighScore; points = winner.points; createDate = Time.now() }));
              seasonATHPrizePool := 0;
            };
          } else {
            weeklyATHPrizePool := weeklyATHPrizePool + seasonRewardPool;
          };
        };
        case (null){};
      };    
      
    };
    */

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

    /* Add back in season 2 if required
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
    */
    
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
      seasonRewards := List.fromArray(stable_weekly_rewards);
    };

    public func getStableMonthlyRewards() : [T.MonthlyRewards] {
      return List.toArray(monthlyRewards);
    };

    public func setStableMonthlyRewards(stable_monthly_rewards : [T.MonthlyRewards]) {
      seasonRewards := List.fromArray(stable_monthly_rewards);
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
    
    public func setupRewardPool(){
      seasonGameweekCount := 30;
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

  public func calculateGameweekRewards(dto: DTOs.WeeklyLeaderboardDTO): async () {
 
    let weeklyRewardsExcludingThisWeek = List.filter<T.WeeklyRewards>(weeklyRewards, func(weeklyRewardsEntry: T.WeeklyRewards){
      not (weeklyRewardsEntry.gameweek == dto.gameweek and weeklyRewardsEntry.seasonId == dto.seasonId)
    });
    let weeklyRewardsBuffer = Buffer.fromArray<T.WeeklyRewards>(List.toArray(weeklyRewardsExcludingThisWeek));

    let rewardPoolOpt = rewardPools.get(dto.seasonId);
    switch (rewardPoolOpt) {
        case (?rewardPool) {
            let weeklyRewardAmount = rewardPool.weeklyLeaderboardPool / Nat64.fromNat(Nat8.toNat(seasonGameweekCount));

            let sortedEntries = Array.sort<T.LeaderboardEntry>(dto.entries, compareEntries);
            let (positions, numPositions) = assignPositions(sortedEntries);

            let scaledPercentages = await scalePercentages(RewardPercentages.percentages, numPositions);
        
            let payouts = calculatePayouts(sortedEntries, positions, numPositions, scaledPercentages);

            let rewardEntriesBuffer = Buffer.fromArray<T.RewardEntry>([]);
            for (i in Iter.range(0, payouts.size() - 1)) {

                let winner = sortedEntries[i];
                let prize = (payouts[i] / 100) * Float.fromInt64(Int64.fromNat64(weeklyRewardAmount * 100_000_000));
                rewardEntriesBuffer.add({
                    principalId = winner.principalId;
                    rewardType = #WeeklyLeaderboard;
                    position = positions[i];
                    amount = Int64.toNat64(Float.toInt64(prize));
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

  private func compareEntries(a: T.LeaderboardEntry, b: T.LeaderboardEntry): Order.Order {
      if (a.points > b.points) { #less }
      else if (a.points < b.points) { #greater }
      else { #equal };
  };

  private func assignPositions(sortedEntries: [T.LeaderboardEntry]): ([Nat], Nat) {
      var positionsBuffer = Buffer.fromArray<Nat>([]);
      var currentPos: Nat = 1;

      for (i in Iter.range(0, Array.size(sortedEntries) - 1)) {
          if (i > 0 and sortedEntries[i].points == sortedEntries[i - 1].points) {
              positionsBuffer.add(Buffer.toArray(positionsBuffer)[i - 1]);
          } else {
              positionsBuffer.add(currentPos);
          };
          currentPos += 1;
      };

      let positions = Buffer.toArray(positionsBuffer);
      let numPositions = if (Array.size(sortedEntries) < 100) {
          Array.size(sortedEntries)
      } else {
          var lastIndex = 99;
          while (lastIndex + 1 < Array.size(sortedEntries) and positions[lastIndex + 1] == positions[99]) {
              lastIndex += 1;
          };
          lastIndex + 1
      };
      
      return (positions, numPositions);
  };

  private func calculatePayouts(sortedEntries: [T.LeaderboardEntry], positions: [Nat], numPositions: Nat, scaledPercentages: [Float]): [Float] {
    let payoutsBuffer = Buffer.fromArray<Float>([]);
    
    var i: Nat = 0;
    while (i < numPositions) {
        var tieCount: Nat = 1;
        var totalPercentage: Float = scaledPercentages[positions[i] - 1];

        while (i + tieCount < numPositions and sortedEntries[i + tieCount].points == sortedEntries[i].points) {
            totalPercentage += scaledPercentages[positions[i + tieCount] - 1];
            tieCount += 1;
        };

        let payoutPerPlayer = totalPercentage / Float.fromInt64(Int64.fromNat64(Nat64.fromNat(tieCount)));
        for (_ in Iter.range(0, tieCount - 1)) {
            payoutsBuffer.add(payoutPerPlayer);
        };

        i += tieCount;
    };

    return Buffer.toArray(payoutsBuffer);
};


  public func scalePercentages(percentages: [Float], actualWinners: Nat): async [Float] {
   
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

  };
};
