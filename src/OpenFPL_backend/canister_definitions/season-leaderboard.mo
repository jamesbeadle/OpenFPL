import T "../types";
import DTOs "../DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Utilities "../utils/utilities";
import Environment "../utils/Environment";

actor class _SeasonLeaderboardCanister() {
  private stable var leaderboard : ?T.SeasonLeaderboard = null;
  private stable var seasonId : ?T.SeasonId = null;
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24;
  private var cyclesCheckTimerId : ?Timer.TimerId = null;

  var main_canister_id = Environment.BACKEND_CANISTER_ID;

  public shared ({ caller }) func createCanister(_seasonId : T.SeasonId, _totalEntries : Nat) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;
    seasonId := ?_seasonId;
    leaderboard := ?{
      seasonId = _seasonId;
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
          entries = List.append(foundLeaderboard.entries, entriesChunk);
          totalEntries = foundLeaderboard.totalEntries;
        };
      };
    };
  };

  public shared query ({ caller }) func getRewardLeaderboard() : async ?T.SeasonLeaderboard {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == main_canister_id;

    switch (leaderboard) {
      case (null) { return null };
      case (?foundLeaderboard) {

        let entriesArray = List.toArray(foundLeaderboard.entries);
        let sortedArray = Array.sort(
          entriesArray,
          func(a : T.LeaderboardEntry, b : T.LeaderboardEntry) : Order.Order {
            if (a.points < b.points) { return #greater };
            if (a.points == b.points) { return #equal };
            return #less;
          },
        );

        let cutoffIndex = 99;
        let lastQualifyingPoints = sortedArray[cutoffIndex].points;
        var lastIndexForPrizes = cutoffIndex;
        let totalEntries : Nat = List.size(foundLeaderboard.entries);

        if (totalEntries <= 0) {
          return null;
        };

        let totalEntriesIndex : Nat = totalEntries - 1;

        while (
          lastIndexForPrizes < totalEntriesIndex and List.toArray(foundLeaderboard.entries)[lastIndexForPrizes + 1].points == lastQualifyingPoints,
        ) {
          lastIndexForPrizes := lastIndexForPrizes + 1;
        };

        let indexes : [Nat] = Array.tabulate<Nat>(Array.size(sortedArray), func(i : Nat) : Nat { i });

        let entriesWithIndex : [(T.LeaderboardEntry, Nat)] = Array.map<Nat, (T.LeaderboardEntry, Nat)>(indexes, func(i : Nat) : (T.LeaderboardEntry, Nat) { (sortedArray[i], i) });

        let qualifyingEntriesWithIndex = Array.filter(
          entriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : Bool {
            let (_, index) = pair;
            index <= lastIndexForPrizes;
          },
        );

        let qualifyingEntriesArray = Array.map(
          qualifyingEntriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : T.LeaderboardEntry {
            let (entry, _) = pair;
            entry;
          },
        );

        let qualifyingEntries = List.fromArray(qualifyingEntriesArray);

        switch (seasonId) {
          case (null) { return null };
          case (?id) {
            return ?{
              seasonId = id;
              entries = qualifyingEntries;
              totalEntries = List.size(qualifyingEntries);
            };
          };
        };
      };
    };
  };

  public shared query ({ caller }) func getEntries(limit : Nat, offset : Nat, searchTerm : Text) : async ?DTOs.SeasonLeaderboardDTO {
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

        let leaderboardDTO : DTOs.SeasonLeaderboardDTO = {
          seasonId = foundLeaderboard.seasonId;
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
