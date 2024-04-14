
import T "types";
import DTOs "DTOs";
import Result "mo:base/Result";

module {

  public class PrivateLeaguesManager() {
    

    public func isLeagueMember(canisterId: T.CanisterId, callerId: T.PrincipalId) : async Bool {
      let private_league_canister = actor (canisterId) : actor {
        isLeagueMember : (callerId : T.PrincipalId) -> async Bool;
      };

      return await private_league_canister.isLeagueMember(callerId);
    };
    
    public func getWeeklyLeaderboard(canisterId: T.CanisterId, seasonId: T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) : async Result.Result<DTOs.WeeklyLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getWeeklyLeaderboard : (seasonId : T.SeasonId, gameweek: T.GameweekNumber, limit : Nat, offset : Nat) -> async DTOs.WeeklyLeaderboardDTO;
      };

      return #ok(await private_league_canister.getWeeklyLeaderboard(seasonId, gameweek, limit, offset));
    };

    public func getMonthlyLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat) : async Result.Result<DTOs.MonthlyLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getMonthlyLeaderboard : (seasonId : T.SeasonId, month: T.CalendarMonth, limit : Nat, offset : Nat) -> async DTOs.MonthlyLeaderboardDTO;
      };

      return #ok(await private_league_canister.getMonthlyLeaderboard(seasonId, month, limit, offset));
    };

    public func getSeasonLeaderboard(canisterId: T.CanisterId, seasonId : T.SeasonId, limit : Nat, offset : Nat) : async Result.Result<DTOs.SeasonLeaderboardDTO, T.Error> {
      let private_league_canister = actor (canisterId) : actor {
        getMonthlyLeaderboard : (seasonId : T.SeasonId, limit : Nat, offset : Nat) -> async DTOs.MonthlyLeaderboardDTO;
      };

      return #ok(await private_league_canister.getMonthlyLeaderboard(seasonId, limit, offset));
    };
    

  };
};
