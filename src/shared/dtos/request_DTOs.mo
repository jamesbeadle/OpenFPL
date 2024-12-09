
import FootballTypes "../types/football_types";
import Base "../types/base_types";
import BettingTypes "../types/betting_types";

module RequestDTOs {

  
  public type RequestFixturesDTO = {
    leagueId: FootballTypes.LeagueId;
    seasonId: FootballTypes.SeasonId;
  };

  public type RequestManagerDTO = {
    managerId : Text;
    seasonId: FootballTypes.SeasonId;
    gameweek: FootballTypes.GameweekNumber;
    month: Base.CalendarMonth;
    clubId: FootballTypes.ClubId;
  };

  public type RequestProfileDTO = {
    principalId : Text;
  };

  public type GetSnapshotPlayers = {
    seasonId: FootballTypes.SeasonId;
    leagueId: FootballTypes.LeagueId;
    gameweek: FootballTypes.GameweekNumber;
  };

  public type UpdateRewardPoolsDTO = {
    seasonId : FootballTypes.SeasonId;
    seasonLeaderboardPool : Nat64;
    monthlyLeaderboardPool : Nat64;
    weeklyLeaderboardPool : Nat64;
    mostValuableTeamPool : Nat64;
    highestScoringMatchPlayerPool : Nat64;
    allTimeWeeklyHighScorePool : Nat64;
    allTimeMonthlyHighScorePool : Nat64;
    allTimeSeasonHighScorePool : Nat64;
  };

  public type UpdateAppStatusDTO = {
    onHold : Bool;
    version: Text;
  };

  public type GetBetslipFixturesDTO = {
    selections: [BettingTypes.Selection];
  };

};
