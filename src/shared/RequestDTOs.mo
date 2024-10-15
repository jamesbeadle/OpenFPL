import T "types";
module RequestDTOs {


  public type RequestFixturesDTO = {
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
  };

  public type GetSnapshotPlayers = {
    seasonId: T.SeasonId;
    leagueId: T.FootballLeagueId;
    gameweek: T.GameweekNumber;
  };

  public type UpdateRewardPoolsDTO = {
    seasonId : T.SeasonId;
    seasonLeaderboardPool : Nat64;
    monthlyLeaderboardPool : Nat64;
    weeklyLeaderboardPool : Nat64;
    mostValuableTeamPool : Nat64;
    highestScoringMatchPlayerPool : Nat64;
    allTimeWeeklyHighScorePool : Nat64;
    allTimeMonthlyHighScorePool : Nat64;
    allTimeSeasonHighScorePool : Nat64;
  };

  public type UpdateSystemStatusDTO = {
    pickTeamSeasonId : T.SeasonId;
    pickTeamGameweek : T.GameweekNumber;
    pickTeamMonth: T.CalendarMonth;
    calculationGameweek : T.GameweekNumber;
    calculationMonth : T.CalendarMonth;
    calculationSeasonId : T.SeasonId;
    seasonActive : Bool;
    transferWindowActive : Bool;
    onHold : Bool;
    version: Text;
  };

  public type CreateLeagueDTO = {
    name: Text;
    abbreviation: Text;
    teamCount: Nat8;
    relatedGender: T.Gender;
    governingBody: Text;
    formed: Int;
    countryId: T.CountryId;
    logo: Blob;
  };

};