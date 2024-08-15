import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Order "mo:base/Order";

import DTOs "../DTOs";
import Environment "../utils/Environment";
import T "../types";
import Utilities "../utils/utilities";

actor class _MonthlyLeaderboardCanister() {
  private stable var leaderboard : ?T.ClubLeaderboard = null;
  private stable var seasonId : ?T.SeasonId = null;
  private stable var month : ?T.CalendarMonth = null;
  private stable var cyclesCheckTimerId : ?Timer.TimerId = null;
  
  private let cyclesCheckInterval : Nat = Utilities.getHour() * 24; //TODO: move

  public shared ({ caller }) func initialise(_seasonId : T.SeasonId, _month : T.CalendarMonth, _clubId : T.ClubId, _totalEntries : Nat) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;
    seasonId := ?_seasonId;
    month := ?_month;
    leaderboard := ?{
      seasonId = _seasonId;
      month = _month;
      clubId = _clubId;
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
          month = foundLeaderboard.month;
          clubId = foundLeaderboard.clubId;
          entries = List.append(foundLeaderboard.entries, entriesChunk);
          totalEntries = foundLeaderboard.totalEntries;
        };
      };
    };
  };

  public shared query ({ caller }) func getEntries(filters: DTOs.PaginationFiltersDTO, searchTerm : Text) : async ?DTOs.ClubLeaderboardDTO {
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

        let leaderboardDTO : DTOs.ClubLeaderboardDTO = {
          seasonId = foundLeaderboard.seasonId;
          month = foundLeaderboard.month;
          clubId = foundLeaderboard.clubId;
          entries = List.toArray(paginatedEntries);
          totalEntries = List.size(foundLeaderboard.entries);
        };

        return ?leaderboardDTO;
      };
    };
  };

  public shared query ({ caller }) func getRewardLeaderboard() : async ?DTOs.ClubLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;

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

        let qualifyingEntries = Array.map(
          qualifyingEntriesWithIndex,
          func(pair : (T.LeaderboardEntry, Nat)) : T.LeaderboardEntry {
            let (entry, _) = pair;
            entry;
          },
        );

        switch (seasonId) {
          case (null) { return null };
          case (?foundSeasonId) {
            switch (leaderboard) {
              case (null) { return null };
              case (?foundLeaderboard) {
                return ?{
                  seasonId = foundSeasonId;
                  clubId = foundLeaderboard.clubId;
                  month = foundLeaderboard.month;
                  entries = qualifyingEntries;
                  totalEntries = Array.size(qualifyingEntries);
                };
              };
            };
          };
        };
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
