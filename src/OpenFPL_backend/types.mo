import List "mo:base/List";

module Types {

  public type FixtureId = Nat32;
  public type SeasonId = Nat16;
  public type GameweekNumber = Nat8;
  public type CalendarMonth = Nat8;
  public type PlayerId = Nat16;
  public type ClubId = Nat16;
  public type ProposalId = Nat;
  public type CountryId = Nat16;
  public type PrincipalId = Text;

  public type WeeklyLeaderboardKey = (SeasonId, GameweekNumber);
  public type MonthlyLeaderboardKey = (SeasonId, CalendarMonth, ClubId);

  public type Error = {
    #NotFound;
    #AlreadyExists;
    #NotAuthorized;
    #NotAllowed;
    #DecodeError;
    #InvalidTeamError;
    #InvalidData;
  };

  public type PlayerPosition = {
    #Goalkeeper;
    #Defender;
    #Midfielder;
    #Forward;
  };

  public type ShirtType = {
    #Filled;
    #Striped;
  };

  public type FixtureStatus = {
    #Unplayed;
    #Active;
    #Complete;
    #Finalised;
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

  public type Manager = {
    principalId : Text;
    username : Text;
    termsAccepted : Bool;
    profilePictureCanisterId : Text;
    favouriteClubId : ClubId;
    createDate : Int;
    transfersAvailable : Nat8;
    bankQuarterMillions : Nat;
    playerIds : [PlayerId];
    captainId : PlayerId;
    goalGetterGameweek : GameweekNumber;
    goalGetterPlayerId : PlayerId;
    passMasterGameweek : GameweekNumber;
    passMasterPlayerId : PlayerId;
    noEntryGameweek : GameweekNumber;
    noEntryPlayerId : PlayerId;
    teamBoostGameweek : GameweekNumber;
    teamBoostClubId : ClubId;
    safeHandsGameweek : GameweekNumber;
    safeHandsPlayerId : PlayerId;
    captainFantasticGameweek : GameweekNumber;
    captainFantasticPlayerId : PlayerId;
    countrymenGameweek : GameweekNumber;
    countrymenCountryId : CountryId;
    prospectsGameweek : GameweekNumber;
    braceBonusGameweek : GameweekNumber;
    hatTrickHeroGameweek : GameweekNumber;
    transferWindowGameweek: GameweekNumber;
    history : List.List<FantasyTeamSeason>;
  };

  public type FantasyTeamSeason = {
    seasonId : SeasonId;
    totalPoints : Int16;
    gameweeks : List.List<FantasyTeamSnapshot>;
  };

  public type FantasyTeamSnapshot = {
    principalId : Text;
    teamName : Text;
    favouriteClubId : ClubId;
    transfersAvailable : Nat8;
    bankQuarterMillions : Nat;
    teamValueQuarterMillions : Nat;
    playerIds : [PlayerId];
    captainId : Nat16;
    gameweek : GameweekNumber;
    goalGetterGameweek : GameweekNumber;
    goalGetterPlayerId : PlayerId;
    passMasterGameweek : GameweekNumber;
    passMasterPlayerId : PlayerId;
    noEntryGameweek : GameweekNumber;
    noEntryPlayerId : PlayerId;
    teamBoostGameweek : GameweekNumber;
    teamBoostClubId : ClubId;
    safeHandsGameweek : GameweekNumber;
    safeHandsPlayerId : PlayerId;
    captainFantasticGameweek : GameweekNumber;
    captainFantasticPlayerId : PlayerId;
    countrymenGameweek : GameweekNumber;
    countrymenCountryId : CountryId;
    prospectsGameweek : GameweekNumber;
    braceBonusGameweek : GameweekNumber;
    hatTrickHeroGameweek : GameweekNumber;
    points : Int16;
    transferWindowGameweek: GameweekNumber;
  };

  public type Season = {
    id : Nat16;
    name : Text;
    year : Nat16;
    fixtures : List.List<Fixture>;
    postponedFixtures : List.List<Fixture>;
  };

  public type Club = {
    id : Nat16;
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
    status : FixtureStatus;
    highestScoringPlayerId : PlayerId;
    events : List.List<PlayerEventData>;
  };

  public type Player = {
    id : PlayerId;
    clubId : ClubId;
    position : PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat;
    dateOfBirth : Int;
    nationality : CountryId;
    seasons : List.List<PlayerSeason>;
    valueHistory : List.List<ValueHistory>;
    onLoan : Bool;
    parentClubId : Nat16;
    isInjured : Bool;
    injuryHistory : List.List<InjuryHistory>;
    transferHistory : List.List<TransferHistory>;
    retirementDate : Int;
  };

  public type PlayerSeason = {
    id : Nat16;
    gameweeks : List.List<PlayerGameweek>;
  };

  public type PlayerGameweek = {
    number : Nat8;
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

  public type ValueHistory = {
    seasonId : Nat16;
    gameweek : Nat8;
    oldValue : Nat;
    newValue : Nat;
  };

  public type InjuryHistory = {
    description : Text;
    injuryStartDate : Int;
    expectedEndDate : Int;
  };

  public type TransferHistory = {
    transferDate : Int;
    transferGameweek : GameweekNumber;
    transferSeason : SeasonId;
    fromClub : ClubId;
    toClub : ClubId;
    loanEndDate : Int;
  };
  
  public type WeeklyLeaderboard = {
    seasonId : SeasonId;
    gameweek : GameweekNumber;
    entries : List.List<LeaderboardEntry>;
  };

  public type ClubLeaderboard = {
    seasonId : SeasonId;
    month : Nat8;
    clubId : ClubId;
    entries : List.List<LeaderboardEntry>;
  };

  public type SeasonLeaderboard = {
    seasonId : SeasonId;
    entries : List.List<LeaderboardEntry>;
  };

  public type LeaderboardEntry = {
    position : Int;
    positionText : Text;
    username : Text;
    principalId : Text;
    points : Int16;
  };

  public type Account = {
    owner : Principal;
    subaccount : Blob;
  };

  public type TimerInfo = {
    id : Int;
    triggerTime : Int;
    callbackName : Text;
  };

  public type ProposalTimer = {
    timerInfo : TimerInfo;
  };

  public type LoanTimer = {
    timerInfo : TimerInfo;
    playerId : Nat16;
    expires : Int;
  };

  public type DataCache = {
    category : Text;
    hash : Text;
  };

  //ENSURE THE CHANGE EVENTS ARE ADDED
  public type SystemState = {
    calculationGameweek: GameweekNumber; //starts at 1 and then after the final game of the gameweek is verified it moves to 2
    calculationMonth: CalendarMonth; //starts at 8 and after the final game of a gameweek is verified it checks the end date of the latest game in the next gameweek and if the follow month then increase the calculationMonth
    calculationSeason: SeasonId; //after final game of season is verified and rewards paid 
    pickTeamGameweek: GameweekNumber; //starts at 1 and 1 hour before the first kick off it turns to 2
    homepageFixturesGameweek: GameweekNumber; //the fixtures up until the morning after the last game
    homepageManagerGameweek: GameweekNumber; //the leaderboard and gameweek points from the prior gameweek until the first game of the calculation gameweek is verified and a leaderboard is produced
  };

  public type Country = {
    id : CountryId;
    name : Text;
    code : Text;
  };

};
