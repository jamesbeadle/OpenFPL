import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Timer "mo:base/Timer";

import DTOs "../DTOs";
import Environment "../utils/Environment";
import T "../types";
import Utilities "../utils/utilities";

actor class _WeeklyLeaderboardCanister() {
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24; //TODO: move
  
  private stable var leaderboard : ?T.WeeklyLeaderboard = null;
  private stable var seasonId : ?T.SeasonId = null;
  private stable var gameweek : ?T.GameweekNumber = null;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;

  public shared ({ caller }) func createCanister(_seasonId : T.SeasonId, _gameweek : T.GameweekNumber, _totalEntries : Nat) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;
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
    assert principalId == Environment.BACKEND_CANISTER_ID;
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

  public shared query ({ caller }) func getEntries(filters: DTOs.PaginationFiltersDTO, searchTerm : Text) : async ?DTOs.WeeklyLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;

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

        let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, filters.offset);
        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, filters.limit);

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
    assert callerPrincipalId == Environment.BACKEND_CANISTER_ID;

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

  public shared query ({ caller }) func getTotalEntries() : async Nat {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;

    switch (leaderboard) {
      case (null) {
        return 0;
      };
      case (?foundLeaderboard) {
        return List.size(foundLeaderboard.entries);
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

    if (balance < 2_000_000_000_000) {
      let openfpl_backend_canister = actor (Environment.BACKEND_CANISTER_ID) : actor {
        requestCanisterTopup : (cycles: Nat) -> async ();
      };
      await openfpl_backend_canister.requestCanisterTopup(2_000_000_000_000);
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

  public shared func topupCanister() : async () {
    let amount = Cycles.available();
    let _ = Cycles.accept<system>(amount);
    Cycles.add<system>(amount);
  };

  public shared ({ caller }) func getCyclesBalance() : async Nat {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;
    return Cycles.balance();
  };

  public shared ({ caller }) func getCyclesAvailable() : async Nat {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;
    return Cycles.available();
  };
};
