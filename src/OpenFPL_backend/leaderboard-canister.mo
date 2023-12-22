import T "types";
import List "mo:base/List";

actor class LeaderboardCanister() {
  private stable var entries : List.List<T.LeaderboardEntry> = List.nil();

  system func preupgrade() { };

  system func postupgrade() {};
};
