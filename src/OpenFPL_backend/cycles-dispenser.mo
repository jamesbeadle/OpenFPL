import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Environment "utils/Environment";
import T "types";
import Root "sns-wrappers/root";

module {

  public class CyclesDispenser() {

    private var canisterIds : List.List<Text> = List.fromArray<Text>([
      Environment.BACKEND_CANISTER_ID,
      Environment.FRONTEND_CANISTER_ID,
      Environment.NEURON_CONTROLLER_CANISTER_ID,
      Environment.SNS_GOVERNANCE_CANISTER_ID,
      Environment.SNS_LEDGER_CANISTER_ID,
      Environment.SNS_ROOT_CANISTER_ID,
      Environment.SNS_INDEX_CANISTER_ID,
      Environment.SNS_SWAP_CANISTER_ID]);

    private var topups : [T.CanisterTopup] = [];

    private var recordSystemEvent : ?((eventLog: T.EventLogEntry) -> ()) = null;

    public func setRecordSystemEventFunction(
      _recordSystemEvent : ((eventLog: T.EventLogEntry) -> ()),
    ) {
      recordSystemEvent := ?_recordSystemEvent;
    };

    public func getStableCanisterIds() : [Text] {
      return List.toArray(canisterIds);
    };

    public func setStableCanisterIds(stable_canister_ids : [Text]) {
      canisterIds := List.fromArray(stable_canister_ids);
    };

    public func getStableTopups() : [T.CanisterTopup] {
      return topups;
    };

    public func setStableTopups(stable_topups : [T.CanisterTopup]) {
      topups := stable_topups;
    };

    public func checkSNSCanisterCycles() : async (){

      let root_canister = actor (Environment.SNS_ROOT_CANISTER_ID) : actor {
        get_sns_canisters_summary : (request: Root.GetSnsCanistersSummaryRequest) -> async Root.GetSnsCanistersSummaryResponse;
      };

      let summary = await root_canister.get_sns_canisters_summary({update_canister_list = ?false});
      
      for(canister in Iter.fromArray(summary.dapps)){
        switch(canister.canister_id){
          case (null) {};
          case (?foundCanisterId){
            let status = canister.status;
            switch(status){
              case (null){};
              case (?foundStatus){
                if (foundStatus.cycles < 10_000_000_000_000) {
                  await requestCanisterTopup(Principal.toText(foundCanisterId), 10_000_000_000_000);
                };
              }
            };
          };
        };
      };
    };

    public func requestCanisterTopup(canisterPrincipal : Text, cycles: Nat) : async () {
      
      let canisterId = List.find<Text>(
        canisterIds,
        func(text : Text) : Bool {
          return text == canisterPrincipal;
        },
      );

      switch (canisterId) {
        case (null) {};
        case (?foundId) {
          let canister_actor = actor (foundId) : actor {
            topupCanister : () -> async ();
          };
          Cycles.add<system>(cycles);
          await canister_actor.topupCanister();
          recordCanisterTopup(foundId, cycles);
        };
      };
    };

    private func recordCanisterTopup(canisterId: T.CanisterId, cyclesAmount: Nat){

      let topup: T.CanisterTopup = {
        canisterId = canisterId;
        cyclesAmount = cyclesAmount;
        topupTime = Time.now();
      };

      let topupBuffer = Buffer.fromArray<T.CanisterTopup>(topups);
      topupBuffer.add(topup);

      topups := Buffer.toArray(topupBuffer);

      switch(recordSystemEvent){
        case null{};
        case (?function){
          function({
            eventDetail = "Canister " # canisterId # " was topped up with " # Nat.toText(cyclesAmount) # " cycles."; 
            eventId = 0;
            eventTime = Time.now();
            eventTitle = "Canister Topup";
            eventType = #CanisterTopup;
          });
        }
      }
      
    };

    public func storeCanisterId(canisterId : Text) : async () {
      let existingCanisterId = List.find<Text>(
        canisterIds,
        func(text : Text) : Bool {
          return text == canisterId;
        },
      );

      switch (existingCanisterId) {
        case (null) {
          canisterIds := List.append(canisterIds, List.make(canisterId));
        };
        case (?foundId) {};
      };
    };

  };
};
