import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import CanisterIds "CanisterIds";

module {

  public class CyclesDispenser() {

    private var canisterIds: List.List<Text> = List.fromArray<Text>([CanisterIds.MAIN_CANISTER_ID]);
  
    public func requestCanisterTopup(canisterPrincipal: Text) : async () {
      let canisterId = List.find<Text>(
        canisterIds,
        func(text: Text) : Bool {
          return text == canisterPrincipal;
        },
      );

      switch(canisterId){
        case (null){};
        case(?foundId){
          let canister_actor = actor (foundId) : actor {
            topupCanister : () -> async ();
          };
          Cycles.add(2000000000000);
          await canister_actor.topupCanister();
        };
      }
    };

    public func storeCanisterId(canisterId: Text) : async (){
      let existingCanisterId = List.find<Text>(
        canisterIds,
        func(text: Text) : Bool {
          return text == canisterId;
        },
      );

      switch(existingCanisterId){
        case (null){
          canisterIds := List.append(canisterIds, List.make(canisterId));
        };
        case(?foundId){};
      };
    };

  };
};
