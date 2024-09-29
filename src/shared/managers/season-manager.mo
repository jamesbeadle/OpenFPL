import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Array "mo:base/Array";
import Order "mo:base/Order";
import DTOs "../../shared/DTOs";
import T "../../shared/types";
import SHA224 "../../shared/lib/SHA224";
import Utilities "../../shared/utils/utilities";
import NetworkEnvironmentVariables "../network_environment_variables";

module {

  public class SeasonManager() {

    var systemState : T.SystemState = {
      calculationGameweek = 7;
      calculationMonth = 10;
      calculationSeasonId = 1;
      onHold = false;
      pickTeamGameweek = 7;
      pickTeamMonth = 10;
      pickTeamSeasonId = 1;
      seasonActive = true;
      transferWindowActive = false;
      version = "2.0.0";
    };
    var rewardPools : TrieMap.TrieMap<T.SeasonId, T.RewardPool> = TrieMap.TrieMap<T.SeasonId, T.RewardPool>(Utilities.eqNat16, Utilities.hashNat16);
    
    private var dataHashes : [T.DataHash] = [
      { category = "clubs"; hash = "OPENFPL_1" },
      { category = "fixtures"; hash = "OPENFPL_1" },
      { category = "weekly_leaderboard"; hash = "OPENFPL_1" },
      { category = "monthly_leaderboards"; hash = "OPENFPL_1" },
      { category = "season_leaderboard"; hash = "OPENFPL_1" },
      { category = "players"; hash = "OPENFPL_1" },
      { category = "player_events"; hash = "OPENFPL_1" },
      { category = "countries"; hash = "OPENFPL_1" },
      { category = "system_state"; hash = "OPENFPL_1" },
    ];

    public func updateDataHash(category : Text) : async () {
      let hashBuffer = Buffer.fromArray<T.DataHash>([]);

      for (hashObj in Iter.fromArray(dataHashes)) {
        if (hashObj.category == category) {
          let randomHash = await SHA224.getRandomHash();
          hashBuffer.add({ category = hashObj.category; hash = randomHash });
        } else { hashBuffer.add(hashObj) };
      };

      dataHashes := Buffer.toArray<T.DataHash>(hashBuffer);
    };

    public func getRewardPool(seasonId: T.SeasonId) : ?T.RewardPool {
        return rewardPools.get(seasonId);
    };

    public func getDataHashes() : Result.Result<[DTOs.DataHashDTO], T.Error> {
      return #ok(dataHashes)
    };
    
    public func getSystemState() : async Result.Result<DTOs.SystemStateDTO, T.Error> {
      return #ok({
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        onHold = systemState.onHold;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        version = systemState.version

      });
    };



    public func setNextPickTeamGameweek() : async () {
      
      var pickTeamGameweek : T.GameweekNumber = 1;
      if (systemState.pickTeamGameweek < 38) {
        pickTeamGameweek := systemState.pickTeamGameweek + 1;
      };

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamGameweek = pickTeamGameweek;
        pickTeamMonth = systemState.pickTeamMonth;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        transferWindowActive = systemState.transferWindowActive;
        seasonActive = true;
        onHold = systemState.onHold;
        version = systemState.version;
      };

      systemState := updatedSystemState;
    };

    public func setFixturesToActive() : async () {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setFixturesToActive : (seasonId : T.SeasonId) -> async ();
      };
      return await data_canister.setFixturesToActive(systemState.pickTeamSeasonId);
    };

    public func setFixturesToCompleted() : async () {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        setFixturesToCompleted : (seasonId : T.SeasonId) -> async ();
      };
      return await data_canister.setFixturesToCompleted(systemState.pickTeamSeasonId);
    };

    public func checkGameweekComplete() : async Bool {
      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getSeason : (seasonId : T.SeasonId) -> async ?T.Season;
      };
      let season = await data_canister.getSeason(systemState.pickTeamSeasonId);
      switch (season) {
        case (null) { return false };
        case (?foundSeason) {
          let fixtures = List.filter<T.Fixture>(
            foundSeason.fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.gameweek == systemState.calculationGameweek;
            },
          );

          let completedFixtures = List.filter<T.Fixture>(
            fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.status == #Finalised;
            },
          );

          return List.size(completedFixtures) == List.size(fixtures);

        };
      };
      return false;
    };

    public func checkMonthComplete() : async Bool {

      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getSeason : (seasonId : T.SeasonId) -> async ?T.Season;
      };
      let season = await data_canister.getSeason(systemState.pickTeamSeasonId);

      switch (season) {
        case (null) {
          return false;
        };
        case (?foundSeason) {

          let gameweekFixtures = List.toArray(
            List.filter<T.Fixture>(
              foundSeason.fixtures,
              func(fixture : T.Fixture) : Bool {
                return fixture.gameweek == systemState.calculationGameweek;
              },
            ),
          );

          let completedGameweekFixtures = Array.filter<T.Fixture>(
            gameweekFixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.status == #Finalised;
            },
          );

          if (Array.size(gameweekFixtures) != Array.size(completedGameweekFixtures)) {
            return false;
          };

          if (systemState.calculationGameweek >= 38) {
            return true;
          };

          let nextGameweekFixtures = List.toArray(
            List.filter<T.Fixture>(
              foundSeason.fixtures,
              func(fixture : T.Fixture) : Bool {
                return fixture.gameweek == systemState.calculationGameweek + 1;
              },
            ),
          );

          let sortedNextFixtures = Array.sort(
            nextGameweekFixtures,
            func(a : T.Fixture, b : T.Fixture) : Order.Order {
              if (a.kickOff < b.kickOff) { return #greater };
              if (a.kickOff == b.kickOff) { return #equal };
              return #less;
            },
          );

          let latestNextFixture = sortedNextFixtures[0];
          let fixtureMonth = Utilities.unixTimeToMonth(latestNextFixture.kickOff);

          return fixtureMonth > systemState.calculationMonth;
        };
      };

      return false;
    };

    public func checkSeasonComplete() : async Bool {

      let data_canister = actor (NetworkEnvironmentVariables.DATA_CANISTER_ID) : actor {
        getSeason : (seasonId : T.SeasonId) -> async ?T.Season;
      };
      let season = await data_canister.getSeason(systemState.pickTeamSeasonId);

      switch (season) {
        case (null) {
          return false;
        };
        case (?foundSeason) {

          if (List.size(foundSeason.fixtures) == 0) {
            return false;
          };

          let completedFixtures = List.filter<T.Fixture>(
            foundSeason.fixtures,
            func(fixture : T.Fixture) : Bool {
              return fixture.status == #Finalised;
            },
          );

          return List.size(completedFixtures) == List.size(foundSeason.fixtures);
        };
      };

      return false;
    };

    public func transferWindowStart() : async (){

    };

    public func transferWindowEnd() : async (){

    };



      
    //Stable variable functions

    public func getStableRewardPools() : [(T.SeasonId, T.RewardPool)] {
      Iter.toArray(rewardPools.entries());
    };

    public func setStableRewardPools(stable_reward_pools : [(T.SeasonId, T.RewardPool)]) {
      rewardPools := TrieMap.fromEntries<T.SeasonId, T.RewardPool>(
        Iter.fromArray(stable_reward_pools),
        Utilities.eqNat16,
        Utilities.hashNat16,
      );
    }; //TODO: Ensure called


    //Stable backup
      //stable data hashes

    //TODO: Stable Backup
    
  };

};