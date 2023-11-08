import List "mo:base/List";

module Types {

  public type FixtureId = Nat32;
  public type SeasonId = Nat16;
  public type GameweekNumber = Nat8;
  public type PlayerId = Nat16;
  public type TeamId = Nat16;
  public type ProposalId = Nat;

  public type Error = {
    #NotFound;
    #AlreadyExists;
    #NotAuthorized;
    #NotAllowed;
    #DecodeError;
    #InvalidTeamError;
    #InvalidData;
  };

  public type Profile = {
    principalName : Text;
    displayName : Text;
    icpDepositAddress : Blob;
    fplDepositAddress : Blob;
    termsAccepted : Bool;
    profilePicture : Blob;
    favouriteTeamId : TeamId;
    membershipType : Nat8;
    createDate : Int;
    subscriptionDate : Int;
    reputation : Nat32; //CAN REMOVE
  };

  public type Season = {
    id : Nat16;
    name : Text;
    year : Nat16;
    gameweeks : List.List<Gameweek>;
    postponedFixtures : List.List<Fixture>;
  };

  public type Gameweek = {
    number : GameweekNumber;
    canisterId : Text;
    fixtures : List.List<Fixture>;
  };

  public type Team = {
    id : Nat16;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : Nat8; //0 = Filled, 1 = Striped, Can add more later.
  };

  public type Fixture = {
    id : Nat32;
    seasonId : SeasonId;
    gameweek : GameweekNumber;
    kickOff : Int;
    homeTeamId : TeamId;
    awayTeamId : TeamId;
    homeGoals : Nat8;
    awayGoals : Nat8;
    status : Nat8; //0 = Unplayed, 1 = Active, 2 = Completed, 3 = Data Finalised
    events : List.List<PlayerEventData>;
    highestScoringPlayerId : Nat16;
  };

  public type Player = {
    id : PlayerId;
    teamId : TeamId;
    position : Nat8; //0 = Goalkeeper //1 = Defender //2 = Midfielder //3 = Forward
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    value : Nat; //Value in £0.25m units
    dateOfBirth : Int;
    nationality : Text;
    seasons : List.List<PlayerSeason>;
    valueHistory : List.List<ValueHistory>;
    onLoan : Bool;
    parentTeamId : Nat16;
    isInjured : Bool;
    injuryHistory : List.List<InjuryHistory>;
    transferHistory : List.List<TransferHistory>;
    retirementDate : Int;
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
    fromTeam : TeamId;
    toTeam : TeamId;
    loanEndDate : Int;
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

  public type Account = {
    owner : Principal;
    subaccount : Blob;
  };

  public type FantasyTeam = {
    principalId : Text;
    teamName : Text;
    favouriteTeamId : TeamId;
    transfersAvailable : Nat8;
    bankBalance : Nat; //Value in £0.25m units
    playerIds : [PlayerId];
    captainId : PlayerId;
    goalGetterGameweek : GameweekNumber;
    goalGetterPlayerId : PlayerId;
    passMasterGameweek : GameweekNumber;
    passMasterPlayerId : PlayerId;
    noEntryGameweek : GameweekNumber;
    noEntryPlayerId : PlayerId;
    teamBoostGameweek : GameweekNumber;
    teamBoostTeamId : TeamId;
    safeHandsGameweek : GameweekNumber;
    safeHandsPlayerId : PlayerId;
    captainFantasticGameweek : GameweekNumber;
    captainFantasticPlayerId : PlayerId;
    braceBonusGameweek : GameweekNumber;
    hatTrickHeroGameweek : GameweekNumber;
  };

  public type UserFantasyTeam = {
    fantasyTeam : FantasyTeam;
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
    favouriteTeamId : TeamId;
    transfersAvailable : Nat8;
    bankBalance : Nat; //Value in £0.25m units
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
    teamBoostTeamId : TeamId;
    safeHandsGameweek : GameweekNumber;
    safeHandsPlayerId : PlayerId;
    captainFantasticGameweek : GameweekNumber;
    captainFantasticPlayerId : PlayerId;
    braceBonusGameweek : GameweekNumber;
    hatTrickHeroGameweek : GameweekNumber;
    points : Int16;
  };

  public type SeasonLeaderboards = {
    seasonLeaderboard : Leaderboard;
    gameweekLeaderboards : List.List<Leaderboard>;
  };

  public type ClubLeaderboard = {
    seasonId : SeasonId;
    month : Nat8;
    clubId : TeamId;
    entries : List.List<LeaderboardEntry>;
  };

  public type Leaderboard = {
    seasonId : SeasonId;
    gameweek : GameweekNumber;
    entries : List.List<LeaderboardEntry>;
  };

  public type LeaderboardEntry = {
    position : Int;
    positionText : Text;
    username : Text;
    principalId : Text;
    points : Int16;
  };

  public type PlayerEventData = {
    fixtureId : FixtureId;
    playerId : Nat16;
    //0 = Appearance
    //1 = Goal Scored
    //2 = Goal Assisted
    //3 = Goal Conceded - Inferred
    //4 = Keeper Save
    //5 = Clean Sheet - Inferred
    //6 = Penalty Saved
    //7 = Penalty Missed
    //8 = Yellow Card
    //9 = Red Card
    //10 = Own Goal
    //11 = Highest Scoring Player
    eventType : Nat8;
    eventStartMinute : Nat8; //use to record event time of all other events
    eventEndMinute : Nat8; //currently only used for Appearance
    teamId : TeamId;
  };

  public type RevaluedPlayer = {
    playerId : PlayerId;
    direction : RevaluationDirection;
  };

  public type RevaluationDirection = {
    #Increase;
    #Decrease;
  };

  public type TimerInfo = {
    id : Int;
    triggerTime : Int;
    callbackName : Text;
    playerId : PlayerId;
    fixtureId : FixtureId;
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

  public type SystemState = {
    activeSeason : Season;
    activeGameweek : GameweekNumber;
    activeMonth : Nat8;
    focusGameweek : GameweekNumber;
  };

};
