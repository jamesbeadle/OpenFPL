import List "mo:base/List";

module _Types {

  public type PrincipalId = Text;
  public type CanisterId = Text;
  public type GameweekNumber = Nat8;
  public type CalendarMonth = Nat8;
  public type SeasonId = Nat16;
  public type FixtureId = Nat32;
  public type ClubId = Nat16;
  public type PlayerId = Nat16;
  public type CountryId = Nat16;
  public type ProposalId = Nat;
  public type TokenId = Nat16;
  public type RustResult = { #Ok : Text; #Err : Text };

  public type Error = {
    #NotFound;
    #AlreadyExists;
    #NotAuthorized;
    #NotAllowed;
    #DecodeError;
    #InvalidTeamError;
    #InvalidData;
    #SystemOnHold;
    #CanisterCreateError;
    #Not11Players;
    #DuplicatePlayerInTeam;
    #MoreThan2PlayersFromClub;
    #NumberPerPositionError;
    #SelectedCaptainNotInTeam;
  };


  //Manager types

  public type Manager = {
    principalId : Text;
    username : Text;
    termsAccepted : Bool;
    favouriteClubId : ClubId;
    createDate : Int;
    transfersAvailable : Nat8;
    monthlyBonusesAvailable : Nat8;
    bankQuarterMillions : Nat16;
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
    transferWindowGameweek : GameweekNumber;
    history : List.List<FantasyTeamSeason>;
    profilePicture : ?Blob;
    profilePictureType : Text;
    ownedPrivateLeagues: List.List<CanisterId>;
    privateLeagueMemberships: List.List<CanisterId>;
  };

  public type FixtureStatusType = {
    #Unplayed;
    #Active;
    #Complete;
    #Finalised;
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

  public type FantasyTeamSeason = {
    seasonId : SeasonId;
    totalPoints : Int16;
    gameweeks : List.List<FantasyTeamSnapshot>;
  };

  public type FantasyTeamSnapshot = {
    principalId : Text;
    username : Text;
    favouriteClubId : ClubId;
    monthlyBonusesAvailable : Nat8;
    transfersAvailable : Nat8;
    bankQuarterMillions : Nat16;
    teamValueQuarterMillions : Nat16;
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
    monthlyPoints : Int16;
    seasonPoints : Int16;
    transferWindowGameweek : GameweekNumber;
    month : CalendarMonth;
    seasonId: SeasonId;
  };

  public type Season = {
    id : Nat16;
    name : Text;
    year : Nat16;
    fixtures : List.List<Fixture>;
    postponedFixtures : List.List<Fixture>;
  };

  public type WeeklyRewards = {
    seasonId : SeasonId;
    gameweek : GameweekNumber;
    rewards : List.List<RewardEntry>;
  };

  public type MonthlyClubRewards = {
    seasonId : SeasonId;
    month : CalendarMonth;
    clubId : ClubId;
    rewards : List.List<RewardEntry>;
  };

  public type MonthlyRewards = {
    seasonId : SeasonId;
    month : CalendarMonth;
    rewards : List.List<RewardEntry>;
  };

  public type SeasonRewards = {
    seasonId : SeasonId;
    rewards : List.List<RewardEntry>;
  };

  public type RewardsList = {
    rewards : List.List<RewardEntry>;
  };

  public type RewardEntry = {
    principalId : Text;
    rewardType : RewardType;
    position : Nat;
    amount : Nat64;
  };

  public type HighScoreRecord = {
    recordType : RecordType;
    points : Int16;
    createDate : Int;
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

  public type Player = {
    id : PlayerId;
    clubId : ClubId;
    position : PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : CountryId;
    seasons : List.List<PlayerSeason>;
    valueHistory : List.List<ValueHistory>;
    status : PlayerStatus;
    currentLoanEndDate : Int;
    parentClubId : Nat16;
    latestInjuryEndDate : Int;
    injuryHistory : List.List<InjuryHistory>;
    transferHistory : List.List<TransferHistory>;
    retirementDate : Int;
  };

  public type PlayerStatus = {
    #Active;
    #Retired;
    #Former;
    #OnLoan;
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
    totalEntries : Nat;
  };

  public type ClubLeaderboard = {
    seasonId : SeasonId;
    month : CalendarMonth;
    clubId : ClubId;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
  };

  public type MonthlyLeaderboard = {
    seasonId : SeasonId;
    month : CalendarMonth;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
  };

  public type SeasonLeaderboard = {
    seasonId : SeasonId;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
  };

  public type LeaderboardEntry = {
    position : Nat;
    positionText : Text;
    username : Text;
    principalId : Text;
    points : Int16;
  };

  public type TeamValueLeaderboard = {
    seasonId : SeasonId;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
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
    pickTeamSeasonId : SeasonId;
    pickTeamGameweek : GameweekNumber;
    calculationGameweek : GameweekNumber;
    calculationMonth : CalendarMonth;
    calculationSeasonId : SeasonId;
    seasonActive : Bool;
    transferWindowActive : Bool;
    onHold : Bool;
  };

  public type Country = {
    id : CountryId;
    name : Text;
    code : Text;
  };

  public type RewardPool = {
    seasonId : SeasonId;
    seasonLeaderboardPool : Nat64;
    monthlyLeaderboardPool : Nat64;
    weeklyLeaderboardPool : Nat64;
    mostValuableTeamPool : Nat64;
    highestScoringMatchPlayerPool : Nat64;
    allTimeWeeklyHighScorePool : Nat64;
    allTimeMonthlyHighScorePool : Nat64;
    allTimeSeasonHighScorePool : Nat64;
  };

  public type WeeklyLeaderboardCanister = {
    seasonId : SeasonId;
    gameweek : GameweekNumber;
    canisterId : Text;
  };

  public type MonthlyLeaderboardsCanister = {
    seasonId : SeasonId;
    month : CalendarMonth;
    canisterId : Text;
  };

  public type SeasonLeaderboardCanister = {
    seasonId : SeasonId;
    canisterId : Text;
  };

  public type PrivateLeague = {
    canisterId: CanisterId;
    createdById: PrincipalId;
    name: Text;
    maxEntrants: Nat16;
    picture: ?Blob;
    banner: ?Blob;
    tokenId: TokenId;
    entryFee: Nat;
    adminFee: Nat8;
    entryType: EntryRequirement;
  };

  public type LeagueMember = {
    principalId: PrincipalId;
    canisterId: CanisterId;
    joinedDate: Int;
    username: Text;
  };

  public type EntryRequirement = {
    #FreeEntry;
    #InviteOnly;
    #PaidEntry;
    #PaidInviteEntry;
  };

  public type TokenInfo = {
    id: TokenId;
    ticker: Text;
    canisterId: CanisterId;
    tokenImageURL: Text;
    fee: Nat;
  };

  public type PaymentChoice = {
    #ICP;
    #FPL;
  };

  public type LeagueInvite = {
    inviteStatus: InviteStatus;
    sent: Int;
    to: PrincipalId;
    from: PrincipalId;
    leagueCanisterId: CanisterId;
  };

  public type InviteStatus = {
    #Sent;
    #Accepted;
    #Rejected;
  };

  public type PrivateLeagueRewardPool = {
    seasonId : SeasonId;
    seasonLeaderboardPool : Nat64;
    monthlyLeaderboardPool : Nat64;
    weeklyLeaderboardPool : Nat64;
    mostValuableTeamPool : Nat64;
  };

  public type CanisterTopup = {
    canisterId: CanisterId;
    topupTime: Int;
    cyclesAmount: Nat;
  };

  public type EventLogEntry = {
    eventId: Nat;
    eventTime: Int;
    eventType: EventLogEntryType;
    eventTitle: Text;
    eventDetail: Text;
  };

  public type EventLogEntryType = {
    #SystemCheck;
    #UnexpectedError;
    #CanisterTopup;
    #ManagerCanisterCreated;
  };

  public type CanisterType = {
    #SNS;
    #Manager;
    #WeeklyLeaderboard;
    #MonthlyLeaderboard;
    #SeasonLeaderboard;
    #Archive;
    #Dapp;
  };

  public type TimerType = {
    #LoanComplete;
    #GameweekBegin;
    #GameKickOff;
    #GameComplete;
    #InjuryExpired;
    #TransferWindow;
  };
};
