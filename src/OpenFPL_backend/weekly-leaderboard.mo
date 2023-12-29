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
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;

  public shared ({ caller }) func addWeeklyLeaderboard(_seasonId : T.SeasonId, _gameweek : T.GameweekNumber, weeklyLeaderboard : T.WeeklyLeaderboard) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == CanisterIds.MAIN_CANISTER_ID;

    leaderboard := ?weeklyLeaderboard;
    seasonId := ?_seasonId;
    gameweek := ?_gameweek;
  };

  public shared query ({ caller }) func getEntries(limit : Nat, offset : Nat) : async ?DTOs.WeeklyLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == CanisterIds.MAIN_CANISTER_ID;

    switch (leaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let droppedEntries = List.drop<T.LeaderboardEntry>(foundLeaderboard.entries, offset);
        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

        let leaderboardDTO : DTOs.WeeklyLeaderboardDTO = {
          seasonId = foundLeaderboard.seasonId;
          gameweek = foundLeaderboard.gameweek;
          entries = List.toArray(paginatedEntries);
          totalEntries = List.size(foundLeaderboard.entries);
        };

        return ?leaderboardDTO;
      };
    };
  };

  public shared query ({ caller }) func getEntry(principalId : Text) : async ?DTOs.LeaderboardEntryDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == CanisterIds.MAIN_CANISTER_ID;
    
    switch (leaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let foundEntry = List.find<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : DTOs.LeaderboardEntryDTO) : Bool {
            return entry.principalId == principalId;
          },
        );
      };
    };
  };

  system func preupgrade() {};

  system func postupgrade() {
    setCheckCyclesTimer();
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

  setCheckCyclesTimer();
};
