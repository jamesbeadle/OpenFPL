import Base "types/base_types";
import T "types/app_types";
import FootballTypes "types/football_types";

module RequestDTOs {


  public type RequestFixturesDTO = {
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

  public type RequestPlayersDTO = {
    seasonId: FootballTypes.SeasonId;
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

  public type UpdateSystemStatusDTO = {
    pickTeamSeasonId : FootballTypes.SeasonId;
    pickTeamGameweek : FootballTypes.GameweekNumber;
    pickTeamMonth: Base.CalendarMonth;
    calculationGameweek : FootballTypes.GameweekNumber;
    calculationMonth : Base.CalendarMonth;
    calculationSeasonId : FootballTypes.SeasonId;
    seasonActive : Bool;
    transferWindowActive : Bool;
    onHold : Bool;
    version: Text;
  };

  public type CreateLeagueDTO = {
    name: Text;
    abbreviation: Text;
    teamCount: Nat8;
    relatedGender: Base.Gender;
    governingBody: Text;
    formed: Int;
    countryId: Base.CountryId;
    logo: Blob;
  };


};