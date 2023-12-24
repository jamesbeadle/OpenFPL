import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";

actor class LeaderboardCanister() {
  private stable var entries : List.List<T.LeaderboardEntry> = List.nil();

  public shared query func getEntries(limit : Nat, offset : Nat) : async [DTOs.LeaderboardEntryDTO] {
    let droppedEntries = List.drop<T.LeaderboardEntry>(entries, offset);
    let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);
    return List.toArray(paginatedEntries);
  };

  public shared query func getEntry(principalId: Text) : async ?DTOs.LeaderboardEntryDTO {
    let entry = List.find(
      entries,
      func(entry : T.LeaderboardEntry) : Bool {
        return entry.principalId == principalId;
      },
    );
    return entry;
  };

  system func preupgrade() { };

  system func postupgrade() {};

  public func checkCanisterCycles() : () {
    let amount = Cycles.available();
    let limit : Nat = 0;//capacity - 20; //TODO: AGAIN WHAT IS THIS?
    let acceptable =
      if (amount <= limit) amount
      else limit;
    let accepted = Cycles.accept(acceptable);
    assert (accepted == acceptable);
  };
};
