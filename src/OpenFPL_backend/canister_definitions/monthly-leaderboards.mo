import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";

import DTOs "../DTOs";
import Environment "../utils/Environment";
import T "../types";
import Utilities "../utils/utilities";

actor class _MonthlyLeaderboardsCanister() {
  private stable var leaderboards : [T.ClubLeaderboard] = [];
  private stable var seasonId : ?T.SeasonId = null;
  private stable var month : ?T.CalendarMonth = null;
  private stable var cyclesCheckTimerId : ?Timer.TimerId = null;
  
  private var entryUpdatesAllowed = false;

  public shared ({ caller }) func initialise(_seasonId : T.SeasonId, _month : T.CalendarMonth, _clubId : T.ClubId, _totalEntries : Nat) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;
    seasonId := ?_seasonId;
    month := ?_month;
    leaderboards := [];
  };

  public shared ({ caller }) func prepareForUpdate() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;
    entryUpdatesAllowed := true;
    leaderboards := [];
  };

  public shared ({ caller }) func addLeaderboardChunk(clubId: T.ClubId, entriesChunk : [T.LeaderboardEntry]) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;


    let leaderboardsBuffer = Buffer.fromArray<T.ClubLeaderboard>([]);
    var found = false;

    for(leaderboard in Iter.fromArray(leaderboards)){
      if(leaderboard.clubId == clubId){
        found := true;
        leaderboardsBuffer.add({
          seasonId = leaderboard.seasonId;
          month = leaderboard.month;
          clubId = leaderboard.clubId;
          entries = List.append(leaderboard.entries, List.fromArray(entriesChunk));
          totalEntries = 0;
        });
      } else {
        leaderboardsBuffer.add(leaderboard);
      }
    };

    if(not found){
      switch(seasonId){
        case (null) {};
        case (?foundSeasonId){
          switch(month){
            case (null) {};
            case (?foundMonth){
              leaderboardsBuffer.add({
                seasonId = foundSeasonId;
                month = foundMonth;
                clubId = clubId;
                entries = List.fromArray(entriesChunk);
                totalEntries = 0;
              });
            }
          }
        };
      };

    };  

    leaderboards := Buffer.toArray(leaderboardsBuffer);
  };

  public shared ({ caller }) func finaliseUpdate() : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;
    entryUpdatesAllowed := false;
    calculateLeaderboards();
  };

  private func calculateLeaderboards(){
    
    switch(seasonId){
      case (null){};
      case (?foundSeasonId){
        switch(month){
          case (null){};
          case (?foundMonth){

            let leaderboardBuffer = Buffer.fromArray<T.ClubLeaderboard>([]);
            for(leaderboard in Iter.fromArray(leaderboards)){
              let sortedGameweekEntries = Array.sort(List.toArray(leaderboard.entries), 
                func(entry1: T.LeaderboardEntry, entry2: T.LeaderboardEntry) : Order.Order{
                if (entry1.points < entry2.points) { return #greater };
                if (entry1.points == entry2.points) { return #equal };
                    return #less;
              });

              let positionedGameweekEntries = Utilities.assignPositionText(List.fromArray<T.LeaderboardEntry>(sortedGameweekEntries)); //TODO update with football god logic

              leaderboardBuffer.add({
                seasonId = foundSeasonId;
                month = foundMonth;
                clubId = leaderboard.clubId;
                entries = positionedGameweekEntries;
                totalEntries = List.size(positionedGameweekEntries);
              });
            };
            leaderboards := Buffer.toArray(leaderboardBuffer);
          };
        }
      }
    };
  };

  public shared query ({ caller }) func getEntries(filters: DTOs.PaginationFiltersDTO, clubId: T.ClubId, searchTerm : Text) : async ?DTOs.ClubLeaderboardDTO {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;

    for(leaderboard in Iter.fromArray(leaderboards)){
      if(leaderboard.clubId == clubId){

        let filteredEntries = List.filter<T.LeaderboardEntry>(
          leaderboard.entries,
          func(entry : T.LeaderboardEntry) : Bool {
            Text.startsWith(entry.username, #text searchTerm);
          },
        );

        let droppedEntries = List.drop<T.LeaderboardEntry>(filteredEntries, filters.offset);
        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, filters.limit);

        let leaderboardDTO : DTOs.ClubLeaderboardDTO = {
          seasonId = leaderboard.seasonId;
          month = leaderboard.month;
          clubId = leaderboard.clubId;
          entries = List.toArray(paginatedEntries);
          totalEntries = List.size(leaderboard.entries);
        };

        return ?leaderboardDTO;

      };
    };
    return null;
  };

  public shared query ({ caller }) func getRewardLeaderboards() : async [DTOs.ClubLeaderboardDTO] {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == Environment.BACKEND_CANISTER_ID;

    switch (seasonId) {
      case (null) { return [] };
      case (?foundSeasonId) {

        let rewardLeaderboardsBuffer = Buffer.fromArray<DTOs.ClubLeaderboardDTO>([]);
        
        for(leaderboard in Iter.fromArray(leaderboards)){

          let entriesArray = List.toArray(leaderboard.entries);
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
          let totalEntries : Nat = List.size(leaderboard.entries);

          if (totalEntries <= 0) {
            return [];
          };

          let totalEntriesIndex : Nat = totalEntries - 1;

          while (
            lastIndexForPrizes < totalEntriesIndex and List.toArray(leaderboard.entries)[lastIndexForPrizes + 1].points == lastQualifyingPoints,
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

          rewardLeaderboardsBuffer.add({
            seasonId = foundSeasonId;
            clubId = leaderboard.clubId;
            month = leaderboard.month;
            entries = qualifyingEntries;
            totalEntries = Array.size(qualifyingEntries);
          });
        };
        return Buffer.toArray(rewardLeaderboardsBuffer);
      };
    };
  };

  public shared query ({ caller }) func getEntry(principalId : Text, clubId: T.ClubId) : async ?DTOs.LeaderboardEntryDTO {
    assert not Principal.isAnonymous(caller);
    let callerPrincipalId = Principal.toText(caller);
    assert callerPrincipalId == Environment.BACKEND_CANISTER_ID;

    for(leaderboard in Iter.fromArray(leaderboards)){
      if(leaderboard.clubId == clubId){
        let entry = List.find<T.LeaderboardEntry>(leaderboard.entries, func(entry: T.LeaderboardEntry){
          entry.principalId == principalId
        });
        return entry;
      }
    };
    return null;
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
