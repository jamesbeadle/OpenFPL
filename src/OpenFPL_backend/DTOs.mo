import T "./types";
import List "mo:base/List";

module DTOs {

  public type ProfileDTO = {
    principalId : Text;
    icpDepositAddress : Blob;
    fplDepositAddress : Blob;
    displayName : Text;
    membershipType : Nat8;
    profilePicture : Blob;
    favouriteTeamId : Nat16;
    createDate : Int;
    reputation : Nat32;
    canUpdateFavouriteTeam : Bool;
  };

  public type AccountBalanceDTO = {
    icpBalance : Nat64;
    fplBalance : Nat64;
  };

  public type PlayerRatingsDTO = {
    players : [T.Player];
    totalEntries : Nat16;
  };

  public type PlayerDTO = {
    id : Nat16;
    teamId : Nat16;
    position : Nat8; //0 = Goalkeeper //1 = Defender //2 = Midfielder //3 = Forward
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    value : Nat;
    dateOfBirth : Int;
    nationality : T.CountryId;
    totalPoints : Int16;
  };

  public type PlayerScoreDTO = {
    id : Nat16;
    points : Int16;
    teamId : Nat16;
    goalsScored : Int16;
    goalsConceded : Int16;
    position : Nat8;
    nationality : T.CountryId;
    dateOfBirth : Int;
    saves : Int16;
    assists : Int16;
    events : List.List<T.PlayerEventData>;
  };

  public type PlayerPointsDTO = {
    id : Nat16;
    gameweek : T.GameweekNumber;
    points : Int16;
    teamId : Nat16;
    position : Nat8;
    events : [T.PlayerEventData];
  };

  public type PlayerDetailDTO = {
    id : T.PlayerId;
    teamId : T.TeamId;
    position : Nat8;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    value : Nat;
    dateOfBirth : Int;
    nationality : T.CountryId;
    seasonId : T.SeasonId;
    gameweeks : [PlayerGameweekDTO];
    valueHistory : [T.ValueHistory];
    onLoan : Bool;
    parentTeamId : Nat16;
    isInjured : Bool;
    injuryHistory : [T.InjuryHistory];
    retirementDate : Int;
  };

  public type PlayerGameweekDTO = {
    number : Nat8;
    events : [T.PlayerEventData];
    points : Int16;
    fixtureId : T.FixtureId;
  };

  public type PaginatedLeaderboard = {
    seasonId : T.SeasonId;
    gameweek : T.GameweekNumber;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type PaginatedClubLeaderboard = {
    seasonId : T.SeasonId;
    month : Nat8;
    clubId : T.TeamId;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type SeasonDTO = {
    id : T.SeasonId;
    name : Text;
    year : Nat16;
  };

  public type FixtureDTO = {
    id : Nat32;
    seasonId : T.SeasonId;
    gameweek : T.GameweekNumber;
    kickOff : Int;
    homeTeamId : T.TeamId;
    awayTeamId : T.TeamId;
    homeGoals : Nat8;
    awayGoals : Nat8;
    status : Nat8;
    highestScoringPlayerId : Nat16;
    events : [T.PlayerEventData];
  };

  public type ManagerDTO = {
    principalId : Text;
    displayName : Text;
    profilePicture : Blob;
    favouriteTeamId : T.TeamId;
    createDate : Int;
    gameweeks : [T.FantasyTeamSnapshot];
    weeklyPosition : Int;
    monthlyPosition : Int;
    seasonPosition : Int;
    weeklyPositionText : Text;
    monthlyPositionText : Text;
    seasonPositionText : Text;
    weeklyPoints : Int16;
    monthlyPoints : Int16;
    seasonPoints : Int16;
  };

  public type UpdateSystemStateDTO = {
    activeGameweek : T.GameweekNumber;
    focusGameweek : T.GameweekNumber;
  };

  public type UpdateFixtureDTO = {
    seasonId : T.SeasonId;
    fixtureId : T.FixtureId;
    gameweek : T.GameweekNumber;
    kickOff : Int;
    status : Nat8;
  };

  public type CountryDTO = {
    id : T.CountryId;
    name : Text;
    code : Text;
  };

};
