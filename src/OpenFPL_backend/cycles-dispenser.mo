import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import Environment "utils/Environment";

module {

  public class CyclesDispenser() {

    var main_canister_id = Environment.BACKEND_CANISTER_ID;

    private var canisterIds : List.List<Text> = List.fromArray<Text>([main_canister_id]);

    public func getStableCanisterIds() : [Text] {
      return List.toArray(canisterIds);
    };

    public func setStableCanisterIds(stable_canister_ids : [Text]) {
      canisterIds := List.fromArray(stable_canister_ids);
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
        };
      };
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
