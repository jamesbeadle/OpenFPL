import T "../../types";
import DTOs "../../DTOs";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Utilities "../../utilities";
module {

  public class LeaderboardComposite() {
    private var seasonLeaderboardCanisterIds : HashMap.HashMap<T.SeasonId, Text> = HashMap.HashMap<T.SeasonId, Text>(100, Utilities.eqNat16, Utilities.hashNat16);
    private var monthlyLeaderboardCanisterIds : HashMap.HashMap<T.MonthlyLeaderboardKey, Text> = HashMap.HashMap<T.MonthlyLeaderboardKey, Text>(100, Utilities.eqMonthlyKey, Utilities.hashMonthlyKey);
    private var weeklyLeaderboardCanisterIds : HashMap.HashMap<T.WeeklyLeaderboardKey, Text> = HashMap.HashMap<T.WeeklyLeaderboardKey, Text>(100, Utilities.eqWeeklyKey, Utilities.hashWeeklyKey);
   
    public func setStableData(
      stable_season_leaderboard_canister_ids:  [(T.SeasonId, Text)],
      stable_monthly_leaderboard_canister_ids:  [(T.MonthlyLeaderboardKey, Text)],
      stable_weekly_leaderboard_canister_ids:  [(T.WeeklyLeaderboardKey, Text)]) {

      seasonLeaderboardCanisterIds := HashMap.fromIter<T.SeasonId, Text>(
        stable_season_leaderboard_canister_ids.vals(),
        stable_season_leaderboard_canister_ids.size(),
        Utilities.eqNat16, 
        Utilities.hashNat16
      );

      monthlyLeaderboardCanisterIds := HashMap.fromIter<T.MonthlyLeaderboardKey, Text>(
        stable_monthly_leaderboard_canister_ids.vals(),
        stable_monthly_leaderboard_canister_ids.size(),
        Utilities.eqMonthlyKey, 
        Utilities.hashMonthlyKey
      );

      weeklyLeaderboardCanisterIds := HashMap.fromIter<T.WeeklyLeaderboardKey, Text>(
        stable_weekly_leaderboard_canister_ids.vals(),
        stable_weekly_leaderboard_canister_ids.size(),
        Utilities.eqWeeklyKey, 
        Utilities.hashWeeklyKey
      );
    };

    public func getWeeklyLeaderboard(seasonId : T.SeasonId, gameweek : T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      
      if(limit > 100){
        return #err(#NotAllowed);
      };
      
      let leaderboardKey: T.WeeklyLeaderboardKey = (seasonId, gameweek);
      let canisterId = weeklyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let weekly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.WeeklyLeaderboardDTO;
          };

          let leaderboardEntries = await weekly_leaderboard_canister.getEntries(limit, offset);
          return #ok(leaderboardEntries);
        };
      };
    };

    public func getMonthlyLeaderboard(seasonId : T.SeasonId, month : T.CalendarMonth, clubId: T.ClubId, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      
      if(limit > 100){
        return #err(#NotAllowed);
      };
      
      let leaderboardKey: T.MonthlyLeaderboardKey = (seasonId, month, clubId);
      let canisterId = monthlyLeaderboardCanisterIds.get(leaderboardKey);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let monthly_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.MonthlyLeaderboardDTO;
          };

          let leaderboardEntries = await monthly_leaderboard_canister.getEntries(limit, offset);
          return #ok(leaderboardEntries);
        };
      };
    };

    public func getSeasonLeaderboard(seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      
      if(limit > 100){
        return #err(#NotAllowed);
      };
      
      let canisterId = seasonLeaderboardCanisterIds.get(seasonId);
      switch(canisterId){
        case (null) {
          return #err(#NotFound);
        };
        case (?foundCanisterId){
          let season_leaderboard_canister = actor (foundCanisterId) : actor {
            getEntries : (limit : Nat, offset : Nat) -> async DTOs.SeasonLeaderboardDTO;
          };

          let leaderboardEntries = await season_leaderboard_canister.getEntries(limit, offset);
          return #ok(leaderboardEntries);
        };
      };
    };
    
    public func getStableSeasonLeaderboardCanisterIds(): [(T.SeasonId, Text)] {
      return Iter.toArray(seasonLeaderboardCanisterIds.entries());
    };

    public func setStableSeasonLeaderboardCanisterIds(stable_season_leaderboard_canister_ids: [(T.SeasonId, Text)])  {
      seasonLeaderboardCanisterIds := HashMap.fromIter<T.SeasonId, Text>(
        stable_season_leaderboard_canister_ids.vals(),
        stable_season_leaderboard_canister_ids.size(),
        Utilities.eqNat16,
        Utilities.hashNat16
      );
    };
    
    public func getStableMonthlyLeaderboardCanisterIds(): [(T.MonthlyLeaderboardKey, Text)] {
      return Iter.toArray(monthlyLeaderboardCanisterIds.entries());
    };

    public func setStableMonthlyLeaderboardCanisterIds(stable_monthly_leaderboard_canister_ids: [(T.MonthlyLeaderboardKey, Text)])  {
      monthlyLeaderboardCanisterIds := HashMap.fromIter<T.MonthlyLeaderboardKey, Text>(
        stable_monthly_leaderboard_canister_ids.vals(),
        stable_monthly_leaderboard_canister_ids.size(),
        Utilities.eqMonthlyKey,
        Utilities.hashMonthlyKey
      );
    };
    
    public func getStableWeeklyLeaderboardCanisterIds(): [(T.WeeklyLeaderboardKey, Text)] {
      return Iter.toArray(weeklyLeaderboardCanisterIds.entries());
    };

    public func setStableWeeklyLeaderboardCanisterIds(stable_weekly_leaderboard_canister_ids: [(T.WeeklyLeaderboardKey, Text)])  {
      weeklyLeaderboardCanisterIds := HashMap.fromIter<T.WeeklyLeaderboardKey, Text>(
        stable_weekly_leaderboard_canister_ids.vals(),
        stable_weekly_leaderboard_canister_ids.size(),
        Utilities.eqWeeklyKey,
        Utilities.hashWeeklyKey
      );
    };     
  };
};
