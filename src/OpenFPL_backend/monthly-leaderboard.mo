import T "types";
import DTOs "DTOs";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Timer "mo:base/Timer";
import Principal "mo:base/Principal";
import CanisterIds "CanisterIds";
import Utilities "utilities";

actor class MonthlyLeaderboardCanister() {
  private stable var leaderboard : ?T.ClubLeaderboard = null;
  private stable var seasonId : ?T.SeasonId = null;
  private stable var clubId : ?T.ClubId = null;
  private stable var gameweek : ?T.GameweekNumber = null;
  private stable var month : ?T.CalendarMonth = null;
  
  public shared ({ caller }) func addMonthlyLeaderboard(_seasonId: T.SeasonId, _gameweek: T.GameweekNumber, _clubId: T.ClubId, clubLeaderboard: T.ClubLeaderboard) : async () {
    assert not Principal.isAnonymous(caller);
    let principalId = Principal.toText(caller);
    assert principalId == CanisterIds.MAIN_CANISTER_ID;
   
    leaderboard := ?clubLeaderboard;
    seasonId := ?_seasonId;
    gameweek := ?_gameweek;
    clubId := ?_clubId;
  };

  public shared query func getEntries (limit : Nat, offset : Nat) : async ?DTOs.MonthlyLeaderboardDTO {
    
    switch(leaderboard){
      case (null){
        return null;
      };
      case (?foundLeaderboard){
        let droppedEntries = List.drop<T.LeaderboardEntry>(foundLeaderboard.entries, offset);
        let paginatedEntries = List.take<T.LeaderboardEntry>(droppedEntries, limit);

        let leaderboardDTO: DTOs.MonthlyLeaderboardDTO = {
          seasonId = foundLeaderboard.seasonId;
          month = foundLeaderboard.month; 
          clubId = foundLeaderboard.clubId; 
          entries = List.toArray(paginatedEntries);
          totalEntries = List.size(foundLeaderboard.entries);
        };

        return ?leaderboardDTO;
      };
    }
  };

  public shared query func getEntry (principalId: Text) : async ?DTOs.LeaderboardEntryDTO {
     switch(leaderboard){
      case (null){
        return null;
      };
      case (?foundLeaderboard){
        let foundEntry = List.find<T.LeaderboardEntry>(
          foundLeaderboard.entries,
          func(entry : DTOs.LeaderboardEntryDTO) : Bool {
            return entry.principalId == principalId;
          },
        );
      };
    }
  };

  system func preupgrade() { };

  system func postupgrade() {};
};
