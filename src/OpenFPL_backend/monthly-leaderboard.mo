import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import CanisterIds "CanisterIds";
import Utilities "utilities";

actor class MonthlyLeaderboardCanister() {
  private stable var entries : List.List<T.LeaderboardEntry> = List.nil();
  
  public func addMonthlyLeaderboard(seasonId: T.SeasonId, month: T.CalendarMonth, club: T.ClubId, monthlyLeaderboard: T.ClubLeaderboard) : async () {
    //TODO
  };
//TODO: Check others
  system func preupgrade() { };

  system func postupgrade() {};
};
