import Cycles "mo:base/ExperimentalCycles";
import Management "Management";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

module {
    
  public func getCanisterStatus_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management) : async ?Management.canister_status_result {
    let cid = { canister_id = Principal.fromActor(a) };
    switch (backendCanisterController) {
      case (null) {
        return null;
      };
      case (?_) {
        let result = await (
          IC.canister_status({
            canister_id = cid.canister_id;
          }),
        );
        return ?result;
      };
    };
  };

  public func updateCanister_(a : actor {}, backendCanisterController : ?Principal, IC : Management.Management) : async () {
    let cid = { canister_id = Principal.fromActor(a) };
    switch (backendCanisterController) {
      case (null) {};
      case (?controller) {
        await (
          IC.update_settings({
            canister_id = cid.canister_id;
            settings = {
              controllers = ?[controller];
              compute_allocation = ?1;
              memory_allocation = null;
              freezing_threshold = ?2_592_000;
              reserved_cycles_limit = null
            };
            sender_canister_version = null
          }),
        );
      };
    };
  };

  public func deleteCanister_(canisterId: Text, IC : Management.Management) : async () {
    await (
      IC.delete_canister({
        canister_id = Principal.fromText(canisterId);
      }),
    );
  };

  public func topup_canister_(a : actor {}, IC : Management.Management, cycles: Nat) : async () {
    let cid = { canister_id = Principal.fromActor(a) };
    Cycles.add<system>(cycles);
    await (
      IC.deposit_cycles({
        canister_id = cid.canister_id;
      }),
    );
  };

};
