
import T "types";
import DTOs "DTOs";

module {

  public class PrivateLeaguesManager() {
    
    private var canisterIds: [T.CanisterId] = [];

    public func isLeagueMember(canisterId: T.CanisterId, calledId: T.PrincipalId) : Bool {
      return false; //todo
    };

    public func getWeeklyLeaderboard(canisterId: T.CanisterId) : DTOs.WeeklyLeaderboardDTO {

    };

    public func getMonthlyLeaderboard(canisterId: T.CanisterId) : DTOs.MonthlyLeaderboardDTO {

    };

    public func getSeasonLeaderboard(canisterId: T.CanisterId) : DTOs.SeasonLeaderboardDTO {

    };

  };
};
