import Base "../types/base_types";
import FootballTypes "../types/football_types";
import DTOs "DTOs";

module GovernanceDTOs {

  public type RevaluePlayerUpDTO = {
    playerId : FootballTypes.ClubId;
    seasonId : FootballTypes.SeasonId;
    gameweek: FootballTypes.GameweekNumber;
  };

  public type RevaluePlayerDownDTO = {
    playerId : FootballTypes.ClubId;
    seasonId : FootballTypes.SeasonId;
    gameweek: FootballTypes.GameweekNumber;
  };

  public type SubmitFixtureDataDTO = {
    gameweek : FootballTypes.GameweekNumber;
    month: Base.CalendarMonth;
    fixtureId : FootballTypes.FixtureId;
    playerEventData : [FootballTypes.PlayerEventData];
  };

  public type AddInitialFixturesDTO = {
    seasonFixtures : [DTOs.FixtureDTO];
  };

  public type MoveFixtureDTO = {
    fixtureId : FootballTypes.FixtureId;
    updatedFixtureGameweek : FootballTypes.GameweekNumber;
    updatedFixtureDate : Int;
  };

  public type PostponeFixtureDTO = {
    fixtureId : FootballTypes.FixtureId;
  };

  public type RescheduleFixtureDTO = {
    postponedFixtureId : FootballTypes.FixtureId;
    updatedFixtureGameweek : FootballTypes.GameweekNumber;
    updatedFixtureDate : Int;
  };

  public type LoanPlayerDTO = {
    seasonId : FootballTypes.SeasonId;
    gameweek: FootballTypes.GameweekNumber;
    playerId : FootballTypes.ClubId;
    loanLeagueId: FootballTypes.LeagueId;
    loanClubId : FootballTypes.ClubId;
    loanEndDate : Int;
  };

  public type TransferPlayerDTO = {
    leagueId: FootballTypes.LeagueId;
    clubId: FootballTypes.ClubId;
    playerId : FootballTypes.ClubId;
    newLeagueId: FootballTypes.LeagueId;
    newClubId : FootballTypes.ClubId;
    newShirtNumber: Nat8;
  };

  public type RecallPlayerDTO = {
    playerId : FootballTypes.ClubId;
  };

  public type CreatePlayerDTO = {
    clubId : FootballTypes.ClubId;
    position : FootballTypes.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Base.CountryId;
    gender: Base.Gender;
  };

  public type UpdatePlayerDTO = {
    playerId : FootballTypes.ClubId;
    position : FootballTypes.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    dateOfBirth : Int;
    nationality : Base.CountryId;
  };

  public type SetPlayerInjuryDTO = {
    playerId : FootballTypes.ClubId;
    description : Text;
    expectedEndDate : Int;
  };

  public type RetirePlayerDTO = {
    playerId : FootballTypes.ClubId;
    retirementDate : Int;
  };

  public type UnretirePlayerDTO = {
    playerId : FootballTypes.ClubId;
  };

  public type UpdateClubDTO = {
    clubId : FootballTypes.ClubId;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : FootballTypes.ShirtType;
  };

  public type PromoteNewClubDTO = {
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : FootballTypes.ShirtType;
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


  public type UpdateLeagueDTO = {
    leagueId: FootballTypes.LeagueId;
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
