import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import CanisterIds "CanisterIds";
import Utilities "utilities";

actor class LeaderboardCanister() {
  private stable var entries : List.List<T.LeaderboardEntry> = List.nil();
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;

  public shared query func getEntries(limit : Nat, offset : Nat) : async [DTOs.LeaderboardEntryDTO] {
    let droppedEntries = List.drop<T.LeaderboardEntry>(entries, offset);
    let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);
    return List.toArray(paginatedEntries);
  };

  public shared query func getEntry(principalId : Text) : async ?DTOs.LeaderboardEntryDTO {
    let entry = List.find(
      entries,
      func(entry : T.LeaderboardEntry) : Bool {
        return entry.principalId == principalId;
      },
    );
    return entry;
  };

  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 500000000000) {
      let openfpl_backend_canister = actor (CanisterIds.MAIN_CANISTER_ID) : actor {
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

  system func preupgrade() {};

  system func postupgrade() {};

  public func getCyclesBalance() : async Nat {
    return Cycles.available();
  };

  public func topupCanister() : async () {
    let amount = Cycles.available();
    let accepted = Cycles.accept(amount);
  };

  setCheckCyclesTimer();
};
