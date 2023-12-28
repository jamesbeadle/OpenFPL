import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import CanisterIds "CanisterIds";
import Utilities "utilities";

actor class WeeklyLeaderboardCanister() {
  private stable var entries : List.List<T.LeaderboardEntry> = List.nil();

  public func addWeeklyLeaderboard(seasonId: T.SeasonId, gamweek: T.GameweekNumber, weeklyLeaderboard: T.WeeklyLeaderboard) : async () {

  };

  system func preupgrade() { };

  system func postupgrade() {};
};
