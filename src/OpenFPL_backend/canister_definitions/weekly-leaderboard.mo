import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Utilities "utilities";
import Environment "Environment";

actor class _WeeklyLeaderboardCanister() {
  private stable var leaderboard : ?T.WeeklyLeaderboard = null;
  private stable var seasonId : ?T.SeasonId = null;
  private stable var gameweek : ?T.GameweekNumber = null;
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;

  var main_canister_id = Environment.BACKEND_CANISTER_ID;

  public shared ({ caller }) func createCanister(_seasonId : T.SeasonId, _gameweek : T.GameweekNumber, _totalEntries : Nat) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    seasonId := ?_seasonId;
    gameweek := ?_gameweek;
    leaderboard := ?{
      seasonId = _seasonId;
      gameweek = _gameweek;
      entries = List.nil();
      totalEntries = _totalEntries;
    };
  };

  public shared ({ caller }) func addLeaderboardChunk(entriesChunk : List.List<T.LeaderboardEntry>) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    switch (leaderboard) {
      case (null) {};
      case (?foundLeaderboard) {
        leaderboard := ?{
          seasonId = foundLeaderboard.seasonId;
          gameweek = foundLeaderboard.gameweek;
          entries = List.append(foundLeaderboard.entries, entriesChunk);
          totalEntries = foundLeaderboard.totalEntries;
        };
      };
    };
  };

  public shared query ({ caller }) func getEntries(limit : Nat, offset : Nat, searchTerm : Text) : async ?DTOs.WeeklyLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    switch (leaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let filteredEntries = List.filter<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : T.LeaderboardEntry) : Bool {
            Text.startsWith(entry.username, #text searchTerm);
          },
        );

        let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, offset);
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
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == main_canister_id;

    switch (leaderboard) {
      case (null) {
        return null;
      };
      case (?foundLeaderboard) {
        let _ = List.find<T.LeaderboardEntry>(
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

    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };

  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 500000000000) {
      let openfpl_backend_canister = actor (main_canister_id) : actor {
        requestCanisterTopup : () -> async ();
      };
      await openfpl_backend_canister.requestCanisterTopup();
    };
    await setCheckCyclesTimer();
  };

  private func setCheckCyclesTimer() : async () {
    switch (cyclesCheckTimerId) {
      case (null) {};
      case (?id) {
        Timer.cancelTimer(id);
        cyclesCheckTimerId := null;
      };
    };
    cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(cyclesCheckInterval), checkCanisterCycles);
  };

  public func topupCanister() : async () {
    let amount = Cycles.available();
    let _ = Cycles.accept<system>(amount);
  };

  public func getCyclesBalance() : async Nat {
    return Cycles.balance();
  };
};
