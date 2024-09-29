import Array "mo:base/Array";
import Cycles "mo:base/ExperimentalCycles";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Timer "mo:base/Timer";

import DTOs "../../shared/DTOs";
import T "../../shared/types";
import Utilities "../../shared/utils/utilities";

actor class _SeasonLeaderboardCanister(controllerPrincipalId: T.PrincipalId) {
  
  private stable var leaderboard : ?T.SeasonLeaderboard = null;
  private stable var leagueId: ?T.FootballLeagueId = null;
  private stable var seasonId : ?T.SeasonId = null;
  private stable var cyclesCheckTimerId : ?Timer.TimerId = null;
  private var entryUpdatesAllowed = false;

  public shared ({ caller }) func initialise(_seasonId : T.SeasonId, _leagueId: T.FootballLeagueId, _totalEntries : Nat) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;
    seasonId := ?_seasonId;
    leaderboard := ?{
      seasonId = _seasonId;
      entries = List.nil();
      totalEntries = _totalEntries;
      leagueId = _leagueId;
    };
  };

  public shared ({ caller }) func prepareForUpdate() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;
    entryUpdatesAllowed := true;
    leaderboard := null;
  };

  public shared ({ caller }) func addLeaderboardChunk(entriesChunk : [T.LeaderboardEntry]) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;
    switch (leaderboard) {
      case (null) {};
      case (?foundLeaderboard) {
        leaderboard := ?{
          seasonId = foundLeaderboard.seasonId;
          entries = List.append(foundLeaderboard.entries, List.fromArray(entriesChunk));
          totalEntries = 0;
        };
      };
    };
  };

  public shared ({ caller }) func finaliseUpdate() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;
    entryUpdatesAllowed := false;
    calculateLeaderboard();
  };

  private func calculateLeaderboard(){

    switch(leaderboard){
      case (?foundLeaderboard){

        let sortedGameweekEntries = Array.sort(List.toArray(foundLeaderboard.entries), func(entry1: T.LeaderboardEntry, entry2: T.LeaderboardEntry) : Order.Order{
          if (entry1.points < entry2.points) { return #greater };
          if (entry1.points == entry2.points) { return #equal };
              return #less;
        });

        let positionedGameweekEntries = Utilities.assignPositionText(List.fromArray<T.LeaderboardEntry>(sortedGameweekEntries)); //TODO update with football god logic

        leaderboard := ?{
          seasonId = foundLeaderboard.seasonId;
          entries = positionedGameweekEntries;
          totalEntries = List.size(positionedGameweekEntries);
        };
      };
      case (null){}
    };    
  };

  public shared query ({ caller }) func getRewardLeaderboard() : async ?DTOs.SeasonLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

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
          case (?id) {

            switch (leagueId){
              case null { return null};
              case (?foundLeagueId){
                return ?{
                  seasonId = id;
                  entries = qualifyingEntries;
                  totalEntries = Array.size(qualifyingEntries);
                  leagueId = foundLeagueId;
                };
              };
            }
          };
        };
      };
    };
  };

  public shared query ({ caller }) func getEntries(filters: DTOs.PaginationFiltersDTO, searchTerm : Text) : async ?DTOs.SeasonLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;

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
    assert callerPrincipalId == controllerPrincipalId;

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
    cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(Utilities.getHour() * 24), checkCanisterCycles);
  };

  private func checkCanisterCycles() : async () {

    let balance = Cycles.balance();

    if (balance < 2_000_000_000_000) {
      let openfpl_backend_canister = actor (controllerPrincipalId) : actor {
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
    cyclesCheckTimerId := ?Timer.setTimer<system>(#nanoseconds(Utilities.getHour() * 24), checkCanisterCycles);
  };

  public shared func topupCanister() : async () {
    let amount = Cycles.available();
    let _ = Cycles.accept<system>(amount);
    Cycles.add<system>(amount);
  };

  public shared ({ caller }) func getCyclesBalance() : async Nat {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;
    return Cycles.balance();
  };

  public shared ({ caller }) func getCyclesAvailable() : async Nat {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == controllerPrincipalId;
    return Cycles.available();
  };
};
