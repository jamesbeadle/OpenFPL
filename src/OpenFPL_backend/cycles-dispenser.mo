import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import Environment "utils/Environment";
import T "types";

module {

  public class CyclesDispenser() {

    private var canisterIds : List.List<Text> = List.fromArray<Text>([Environment.BACKEND_CANISTER_ID]);
    private var topups : [T.CanisterTopup] = [];

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

    public func requestCanisterTopup(canisterPrincipal : Text) : async () {
      
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
          Cycles.add<system>(2_000_000_000_000);
          await canister_actor.topupCanister();
          recordCanisterTopup(foundId, 2_000_000_000_000, );
        };
      };
    };

    private func recordCanisterTopup(canisterId: T.CanisterId, cyclesAmount: Nat64){

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
