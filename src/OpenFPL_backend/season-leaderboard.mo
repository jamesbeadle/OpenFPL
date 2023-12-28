import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import CanisterIds "CanisterIds";
import Utilities "utilities";

actor class SeasonLeaderboardCanister() {
  private stable var leaderboard : ?T.SeasonLeaderboard = null;
  private stable var seasonId : ?T.SeasonId = null;
  
  public shared ({ caller }) func addSeasonLeaderboard(_seasonId: T.SeasonId, seasonLeaderboard: T.SeasonLeaderboard) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == CanisterIds.MAIN_CANISTER_ID;
   
    leaderboard := ?seasonLeaderboard;
    seasonId := ?_seasonId;
  };
  
//TODO: Check others

  system func preupgrade() { };

  system func postupgrade() {};
};
