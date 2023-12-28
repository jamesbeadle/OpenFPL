import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Order "mo:base/Order";
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

  public shared query func getRewardLeaderboard() : async ?T.SeasonLeaderboard{
    switch(leaderboard){
      case (null) {return null};
      case (?foundLeaderboard){

        let entriesArray = List.toArray(foundLeaderboard.entries);
        let sortedArray = Array.sort(entriesArray,
          func(a: T.LeaderboardEntry, b: T.LeaderboardEntry): Order.Order {
            if (a.points < b.points) { return #greater; };
            if (a.points == b.points) { return #equal; };
            return #less;
          }
        );

        let cutoffIndex = 99;
        let lastQualifyingPoints = sortedArray[cutoffIndex].points;
        var lastIndexForPrizes = cutoffIndex;
        let totalEntries: Nat = List.size(foundLeaderboard.entries);

        if(totalEntries <= 0){
          return null;
        };

        let totalEntriesIndex: Nat = totalEntries - 1;
        
        while (lastIndexForPrizes < totalEntriesIndex and
              List.toArray(foundLeaderboard.entries)[lastIndexForPrizes + 1].points == lastQualifyingPoints) {
            lastIndexForPrizes := lastIndexForPrizes + 1;
        };


        let indexes: [Nat] = Array.tabulate<Nat>(Array.size(sortedArray), func (i: Nat): Nat { i });

        let entriesWithIndex: [(T.LeaderboardEntry, Nat)] = Array.map<Nat, (T.LeaderboardEntry, Nat)>(indexes, func (i: Nat): (T.LeaderboardEntry, Nat) {
          (sortedArray[i], i)
        });

        let qualifyingEntriesWithIndex = Array.filter(entriesWithIndex, func (pair : (T.LeaderboardEntry, Nat)) : Bool {
          let (entry, index) = pair;
          index <= lastIndexForPrizes
        });

        let qualifyingEntriesArray = Array.map(qualifyingEntriesWithIndex, func (pair : (T.LeaderboardEntry, Nat)) : T.LeaderboardEntry {
          let (entry, _) = pair;
          entry
        });

        let qualifyingEntries = List.fromArray(qualifyingEntriesArray);

        switch(seasonId){
          case (null) {return null};
          case (?id) {
            return ?{
                seasonId = id;
                entries = qualifyingEntries;
                totalEntries = List.size(qualifyingEntries);
            }
          };
        };
      }
    }
  };
  
//TODO: Check others neeed client functions

  system func preupgrade() { };

  system func postupgrade() {};
};
