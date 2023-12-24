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

  public type RewardType = {
    #SeasonLeaderboard;
    #MonthlyLeaderboard;
    #WeeklyLeaderboard;
    #MostValuableTeam;
    #HighestScoringPlayer;
    #WeeklyATHScore;
    #MonthlyATHScore;
    #SeasonATHScore;
  };

  public type RecordType = {
    #WeeklyHighScore;
    #MonthlyHighScore;
    #SeasonHighScore;
  };

  public type Manager = {
    principalId : Text;
    username : Text;
    termsAccepted : Bool;
    profilePictureCanisterId : Text;
    favouriteClubId : ClubId;
    createDate : Int;
    transfersAvailable : Nat8;
    monthlyBonusesAvailable : Nat8;
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
    monthlyBonusesAvailable : Nat8;
    transfersAvailable : Nat8;
    bankQuarterMillions : Nat;
    teamValueQuarterMillions : Nat;
    playerIds : [PlayerId];
    captainId : PlayerId;
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

  public type WeeklyRewards = {
    gameweek: GameweekNumber;
    rewards: List.List<RewardEntry>;
  };

  public type MonthlyRewards = {
    month: CalendarMonth;
    rewards: List.List<RewardEntry>;
  };

  public type SeasonRewards = {
    season: SeasonId;
    rewards: List.List<RewardEntry>;
  };

  public type RewardsList = {
    rewards: List.List<RewardEntry>;
  };

  public type RewardEntry = {
    principalId: Text;
    rewardType: RewardType;
    position: Nat;
    amount: Nat64;
  };

  public type HighScoreRecord = {
    recordType: RecordType;
    points: Int16;
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
    loanEndDate: Int;
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

  public type SystemState = {
    pickTeamSeason: SeasonId; 
    pickTeamGameweek: GameweekNumber; 
    calculationGameweek: GameweekNumber; 
    calculationMonth: CalendarMonth;
    calculationSeason: SeasonId; 
    transferWindowActive: Bool;
  };

  public type Country = {
    id : CountryId;
    name : Text;
    code : Text;
  };

  public type RewardPool = {
    seasonId: SeasonId;
    seasonLeaderboardPool: Nat64;
    monthlyLeaderboardPool: Nat64;
    weeklyLeaderboardPool: Nat64;
    mostValuableTeamPool: Nat64;
    highestScoringMatchPlayerPool: Nat64;
    allTimeWeeklyHighScorePool: Nat64;
    allTimeMonthlyHighScorePool: Nat64;
    allTimeSeasonHighScorePool: Nat64;
  }

};
