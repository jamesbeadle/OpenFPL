import T "types";
module RequestDTOs {


  public type RequestFixturesDTO = {
    leagueId: T.FootballLeagueId;
    seasonId: T.SeasonId;
  };

  public type RequestManagerDTO = {
    managerId : Text;
    seasonId: T.SeasonId;
    gameweek: T.GameweekNumber;
    month: T.CalendarMonth;
    clubId: T.ClubId;
  };

  public type RequestProfileDTO = {
    principalId : Text;
  };

  public type RequestPlayersDTO = {
    seasonId: T.SeasonId;
    leagueId: T.FootballLeagueId;
  };


};