import T "types";
import List "mo:base/List";

actor class LeaderboardCanister() {
  private stable var entries : List.List<T.LeaderboardEntry> = List.nil();

  //TODO: add in functions defined in leaderboard composite

  system func preupgrade() { };

  system func postupgrade() {};
};
