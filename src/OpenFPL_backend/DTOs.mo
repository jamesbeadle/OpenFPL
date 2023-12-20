import T "types";
import List "mo:base/List";

module DTOs {

  public type SystemStateDTO = {
    calculationGameweek: T.GameweekNumber;
    calculationMonth: T.CalendarMonth;
    calculationSeason: T.SeasonId;
    pickTeamGameweek: T.GameweekNumber;
    homepageFixturesGameweek: T.GameweekNumber;
    homepageManagerGameweek: T.GameweekNumber;
  };

  public type RevaluePlayerUpDTO = {
    playerId : T.PlayerId
  };

  public type RevaluePlayerDownDTO = {
    playerId : T.PlayerId
  };

  public type SubmitFixtureDataDTO = {
    fixtureId : T.FixtureId;
    playerEventData : [T.PlayerEventData];
  };
  
  public type AddInitialFixturesDTO = {
    seasonId : T.SeasonId;
    seasonFixtures : [T.Fixture];
  };
  
  public type RescheduleFixtureDTO = {
    fixtureId : T.FixtureId;
    updatedFixtureGameweek : T.GameweekNumber;
    updatedFixtureDate : Int
  };
  
  public type LoanPlayerDTO = {
    playerId : T.PlayerId;
    loanClubId : T.ClubId;
    loanEndDate : Int;
  };
  
  public type TransferPlayerDTO = {
    playerId : T.PlayerId;
    newClubId : T.ClubId;
  };
  
  public type RecallPlayerDTO = {
    playerId : T.PlayerId
  };

  public type CreatePlayerDTO = {
    clubId : T.ClubId;
    position : T.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    value : Nat;
    dateOfBirth : Int;
    nationality : T.CountryId;
  };

  public type UpdatePlayerDTO = {
    playerId : T.PlayerId;
    position : Nat8;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    dateOfBirth : Int;
    nationality : T.CountryId;
  };

  public type SetPlayerInjuryDTO = {
    playerId : T.PlayerId;
    description : Text;
    expectedEndDate : Int;
  };

  public type RetirePlayerDTO = {
    playerId : T.PlayerId;
    retirementDate : Int;
  };

  public type UnretirePlayerDTO = {
    playerId : T.PlayerId;
  };

  public type UpdateClubDTO = {

  };

  public type PromoteFormerClubDTO = {
    clubId : T.ClubId
  };

  public type PromoteNewClubDTO = {
    name : Text;
    friendlyName : Text;
    abbreviatedName : Text;
    primaryHexColour : Text;
    secondaryHexColour : Text;
    thirdHexColour : Text;
  };


  public type ProfileDTO = {
    principalId : Text;
    displayName : Text;
    profilePicture : Blob;
    favouriteClubId : Nat16;
    createDate : Int;
    canUpdateFavouriteClub : Bool;
  };

  public type PlayerRatingsDTO = {
    players : [T.Player];
    totalEntries : Nat16;
  };

  public type PlayerDTO = {
    id : Nat16;
    clubId : T.ClubId;
    position : T.PlayerPosition;
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
    clubId : T.ClubId;
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
    clubId : T.ClubId;
    position : Nat8;
    events : [T.PlayerEventData];
  };

  public type PlayerDetailDTO = {
    id : T.PlayerId;
    clubId : T.ClubId;
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
    parentClubId : Nat16;
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
    entries : [LeaderboardEntryDTO];
    totalEntries : Nat;
  };

  public type LeaderboardEntryDTO = {

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
    homeClubId : T.ClubId;
    awayClubId : T.ClubId;
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
    favouriteClubId : T.ClubId;
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

  public type DataCacheDTO = {
    category : Text;
    hash : Text;
  };

  public type WeeklyLeaderboardDTO = {
    seasonId : T.SeasonId;
    gameweek : T.GameweekNumber;
    entries : List.List<T.LeaderboardEntry>;

  };

  public type MonthlyLeaderboardDTO = {
    seasonId : T.SeasonId;
    month : Nat8;
    clubId : T.ClubId;
    entries : [LeaderboardEntryDTO];
    totalEntries : Nat;
  };

  public type UpdateFantasyTeamDTO = {

  };

};
