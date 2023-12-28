import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import CanisterIds "CanisterIds";
import Utilities "utilities";

actor class WeeklyLeaderboardCanister() {
  private stable var leaderboard : ?T.WeeklyLeaderboard = null;
  private stable var seasonId : ?T.SeasonId = null;
  private stable var gameweek : ?T.GameweekNumber = null;
  
  public shared ({ caller }) func addWeeklyLeaderboard(_seasonId: T.SeasonId, _gameweek: T.GameweekNumber, weeklyLeaderboard: T.WeeklyLeaderboard) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == CanisterIds.MAIN_CANISTER_ID;
   
    leaderboard := ?weeklyLeaderboard;
    seasonId := ?_seasonId;
    gameweek := ?_gameweek;
  };
//TODO: Check others

  system func preupgrade() { };

  system func postupgrade() {};
};
