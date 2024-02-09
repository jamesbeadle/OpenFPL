import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Text "mo:base/Text";
import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import CanisterIds "CanisterIds";
import Utilities "utilities";
import Environment "Environment";

actor class ManagerCanister() {
  private var managers : TrieMap.TrieMap<T.PrincipalId, T.Manager> = TrieMap.TrieMap<T.PrincipalId, T.Manager>(Text.equal, Text.hash);
  

  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;

  let network = Environment.DFX_NETWORK;
  var main_canister_id = CanisterIds.MAIN_CANISTER_IC_ID;
  if (network == "local") {
    main_canister_id := CanisterIds.MAIN_CANISTER_LOCAL_ID;
  };

  public shared ({ caller }) func createCanister(_seasonId : T.SeasonId, _totalEntries : Nat) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
  };

  public shared ({ caller }) func getManager(principalId : T.PrincipalId) : async ?T.Manager {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    return managers.get(principalId);
  };

  public shared query ({ caller }) func updateManager(manager: T.Manager) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    managers.put(manager.principalId, manager);
  };


  private stable var stable_managers : [(T.PrincipalId, T.Manager)] = [];
  private func getStableManagers() : [(T.PrincipalId, T.Manager)] {
    Iter.toArray(managers.entries());
  };

  system func preupgrade() {
    stable_managers := getStableManagers();
  };

  system func postupgrade() {
    setCheckCyclesTimer();
    for ((principalId, manager) in stable_managers.vals()) {
      managers.put(principalId, manager);
    };
  };


  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 500000000000) {
      let openfpl_backend_canister = actor (main_canister_id) : actor {
        requestCanisterTopup : () -> async ();
      };
      await openfpl_backend_canister.requestCanisterTopup();
    };
    setCheckCyclesTimer();
  };

  private func setCheckCyclesTimer() {
    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    cyclesCheckTimerId := ?Timer.setTimer(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };

  public func topupCanister() : async () {
    let amount = Cycles.available();
    let accepted = Cycles.accept(amount);
  };

  public func getCyclesBalance() : async Nat {
    return Cycles.balance();
  };

  setCheckCyclesTimer();
};
