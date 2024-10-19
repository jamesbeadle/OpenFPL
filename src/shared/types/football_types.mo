import Base "base_types";
import List "mo:base/List";
module FootballTypes {

  public type GameweekNumber = Nat8;
  public type SeasonId = Nat16;
  public type FixtureId = Nat32;
  
  public type LeagueId = Nat16;
  public type ClubId = Nat16;
  public type PlayerId = Nat16;
  
  public type ProposalId = Nat;

  public type Country = {
    id : Base.CountryId;
    name : Text;
    code : Text;
  };
    
  public type League = {
    id: LeagueId;
    name: Text;
    abbreviation: Text;
    teamCount: Nat8;
    relatedGender: Base.Gender;
    governingBody: Text;
    formed: Int;
    countryId: Base.CountryId;
    logo: Blob;
  };

  public type Club = {
    id : ClubId;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : ShirtType;
  };

  public type Fixture = {
    id : FixtureId;
    seasonId : SeasonId;
    gameweek : GameweekNumber;
    kickOff : Int;
    homeClubId : ClubId;
    awayClubId : ClubId;
    homeGoals : Nat8;
    awayGoals : Nat8;
    status : FixtureStatusType;
    highestScoringPlayerId : PlayerId;
    events : List.List<PlayerEventData>;
  };


  public type Season = {
    id : Nat16;
    name : Text;
    year : Nat16;
    fixtures : List.List<Fixture>;
    postponedFixtures : List.List<Fixture>;
  };

  public type Player = {
    id : PlayerId;
    leagueId: LeagueId;
    clubId : ClubId;
    position : PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Base.CountryId;
    seasons : List.List<PlayerSeason>;
    valueHistory : List.List<ValueHistory>;
    status : PlayerStatus;
    currentLoanEndDate : Int;
    parentLeagueId: LeagueId;
    parentClubId : ClubId;
    latestInjuryEndDate : Int;
    injuryHistory : List.List<InjuryHistory>;
    transferHistory : List.List<TransferHistory>;
    retirementDate : Int;
    gender: Base.Gender;
  };

  public type PlayerSeason = {
    id : SeasonId;
    gameweeks : List.List<PlayerGameweek>;
    totalPoints : Int16;
  };

  public type PlayerGameweek = {
    number : GameweekNumber;
    events : List.List<PlayerEventData>;
    points : Int16;
  };

  public type PlayerEventData = {
    fixtureId : FixtureId;
    playerId : Nat16;
    eventType : PlayerEventType;
    eventStartMinute : Nat8;
    eventEndMinute : Nat8;
    clubId : ClubId;
  };

  public type PlayerPosition = {
      #Goalkeeper;
      #Defender;
      #Midfielder;
      #Forward;
  };


  public type PlayerStatus = {
      #Active;
      #Retired;
      #OnLoan;
      #FreeAgent;
  };

  public type ShirtType = {
      #Filled;
      #Striped;
  };

  public type GoalType = {
      #LeftFoot;
      #RightFoot;
      #Header;
      #OutsideBox;
      #DirectSetPiece;
  };

  public type PlayerEventType = {
      #Appearance;
      #Goal;
      #GoalAssisted;
      #GoalConceded;
      #KeeperSave;
      #CleanSheet;
      #PenaltySaved;
      #PenaltyMissed;
      #YellowCard;
      #RedCard;
      #OwnGoal;
      #HighestScoringPlayer;
  };

  public type ValueHistory = {
    changedOn: Int;
    oldValue : Nat16;
    newValue : Nat16;
  };

  public type InjuryHistory = {
    description : Text;
    injuryStartDate : Int;
    expectedEndDate : Int;
  };

  public type TransferHistory = {
    transferDate : Int;
    fromLeagueId: LeagueId;
    toLeagueId: LeagueId;
    fromClub : ClubId;
    toClub : ClubId;
    loanEndDate : Int;
  };

  public type FixtureStatusType = {
    #Unplayed;
    #Active;
    #Complete;
    #Finalised;
  };
};
