import T "types";
import DTOs "DTOs";
import List "mo:base/List";

actor class LeaderboardCanister() {
  private stable var entries : List.List<T.LeaderboardEntry> = List.nil();

  //TODO: add in functions defined in leaderboard composite
  public shared query func getEntries(limit : Nat, offset : Nat) : async [DTOs.LeaderboardEntryDTO] {
    return [];
  };

  public shared query func getEntry(principalId: Text) : async ?DTOs.LeaderboardEntryDTO {
    return null;
  };

  system func preupgrade() { };

  system func postupgrade() {};
};
