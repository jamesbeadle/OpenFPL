import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import TrieMap "mo:base/TrieMap";
import List "mo:base/List";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Timer "mo:base/Timer";
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

    public func incrementCalculationGameweek() : async () {
      
      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek + 1;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamMonth = systemState.pickTeamMonth;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
        version = systemState.version;
      };

      systemState := updatedSystemState;
    };

    public func incrementCalculationMonth() : async () {
      
      var month = systemState.calculationMonth;
      if (month == 12) {
        month := 1;
      } else {
        month := month + 1;
      };

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = month;
        calculationSeasonId = systemState.calculationSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamMonth = systemState.pickTeamMonth;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
        version = systemState.version;
      };

      systemState := updatedSystemState;
    };

    public func incrementCalculationSeason() : async () {
      
      var seasonId = systemState.calculationSeasonId;
      
      var nextSeasonId = seasonId + 1;

      let updatedSystemState : T.SystemState = {
        calculationGameweek = systemState.calculationGameweek;
        calculationMonth = systemState.calculationMonth;
        calculationSeasonId = nextSeasonId;
        pickTeamSeasonId = systemState.pickTeamSeasonId;
        pickTeamGameweek = systemState.pickTeamGameweek;
        pickTeamMonth = systemState.pickTeamMonth;
        seasonActive = systemState.seasonActive;
        transferWindowActive = systemState.transferWindowActive;
        onHold = systemState.onHold;
        version = systemState.version;
      };

      systemState := updatedSystemState;
    };

    public func transferWindowStart() : async (){

    };

    public func transferWindowEnd() : async (){

    };



      
    //Stable variable functions


    public func getStableSystemState() : T.SystemState {
      return systemState;
    };

    public func setStableSystemState(stable_system_state : T.SystemState) {
      systemState := stable_system_state;
    };
    //TODO: Ensure called



    //TODO: Stable Backup
      //stable data hashes

    
  };

};