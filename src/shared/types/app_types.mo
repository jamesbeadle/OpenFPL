import List "mo:base/List";
import Base "mo:waterway-mops/BaseTypes";
import FootballTypes "mo:waterway-mops/FootballTypes";

module AppTypes {

  public type TokenId = Nat16;

  public type Error = {
    #NotFound;
    #AlreadyExists;
    #NotAuthorized;
    #NotAllowed;
    #DecodeError;
    #InvalidData;
    #SystemOnHold;
    #CanisterCreateError;
    #Not11Players;
    #DuplicatePlayerInTeam;
    #MoreThan2PlayersFromClub;
    #NumberPerPositionError;
    #SelectedCaptainNotInTeam;
    #InvalidBonuses;
    #TeamOverspend;
    #TooManyTransfers;
    #InvalidGameweek;
    #InsufficientFunds;
  };

  //Manager types

  public type Manager = {
    principalId : Base.PrincipalId;
    canisterId : Base.CanisterId;
    username : Text;
    termsAccepted : Bool;
    profilePicture : ?Blob;
    profilePictureType : Text;
    createDate : Int;
    favouriteClubId : ?FootballTypes.ClubId;
    transfersAvailable : Nat8;
    monthlyBonusesAvailable : Nat8;
    bankQuarterMillions : Nat16;
    playerIds : [FootballTypes.PlayerId];
    captainId : FootballTypes.PlayerId;
    goalGetterGameweek : FootballTypes.GameweekNumber;
    goalGetterPlayerId : FootballTypes.PlayerId;
    passMasterGameweek : FootballTypes.GameweekNumber;
    passMasterPlayerId : FootballTypes.PlayerId;
    noEntryGameweek : FootballTypes.GameweekNumber;
    noEntryPlayerId : FootballTypes.PlayerId;
    teamBoostGameweek : FootballTypes.GameweekNumber;
    teamBoostClubId : FootballTypes.ClubId;
    safeHandsGameweek : FootballTypes.GameweekNumber;
    safeHandsPlayerId : FootballTypes.PlayerId;
    captainFantasticGameweek : FootballTypes.GameweekNumber;
    captainFantasticPlayerId : FootballTypes.PlayerId;
    oneNationGameweek : FootballTypes.GameweekNumber;
    oneNationCountryId : Base.CountryId;
    prospectsGameweek : FootballTypes.GameweekNumber;
    braceBonusGameweek : FootballTypes.GameweekNumber;
    hatTrickHeroGameweek : FootballTypes.GameweekNumber;
    transferWindowGameweek : FootballTypes.GameweekNumber;
    history : List.List<FantasyTeamSeason>;
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
    seasonId : FootballTypes.SeasonId;
    totalPoints : Int16;
    gameweeks : List.List<FantasyTeamSnapshot>;
  };

  public type FantasyTeamSnapshot = {
    principalId : Text;
    username : Text;
    favouriteClubId : ?FootballTypes.ClubId;
    monthlyBonusesAvailable : Nat8;
    transfersAvailable : Nat8;
    bankQuarterMillions : Nat16;
    teamValueQuarterMillions : Nat16;
    playerIds : [FootballTypes.PlayerId];
    captainId : FootballTypes.PlayerId;
    gameweek : FootballTypes.GameweekNumber;
    goalGetterGameweek : FootballTypes.GameweekNumber;
    goalGetterPlayerId : FootballTypes.PlayerId;
    passMasterGameweek : FootballTypes.GameweekNumber;
    passMasterPlayerId : FootballTypes.PlayerId;
    noEntryGameweek : FootballTypes.GameweekNumber;
    noEntryPlayerId : FootballTypes.PlayerId;
    teamBoostGameweek : FootballTypes.GameweekNumber;
    teamBoostClubId : FootballTypes.ClubId;
    safeHandsGameweek : FootballTypes.GameweekNumber;
    safeHandsPlayerId : FootballTypes.PlayerId;
    captainFantasticGameweek : FootballTypes.GameweekNumber;
    captainFantasticPlayerId : FootballTypes.PlayerId;
    oneNationGameweek : FootballTypes.GameweekNumber;
    oneNationCountryId : Base.CountryId;
    prospectsGameweek : FootballTypes.GameweekNumber;
    braceBonusGameweek : FootballTypes.GameweekNumber;
    hatTrickHeroGameweek : FootballTypes.GameweekNumber;
    points : Int16;
    monthlyPoints : Int16;
    seasonPoints : Int16;
    transferWindowGameweek : FootballTypes.GameweekNumber;
    month : Base.CalendarMonth;
    seasonId : FootballTypes.SeasonId;
  };

  public type WeeklyRewards = {
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
    rewards : List.List<RewardEntry>;
  };

  public type MonthlyClubRewards = {
    seasonId : FootballTypes.SeasonId;
    month : Base.CalendarMonth;
    clubId : FootballTypes.ClubId;
    rewards : List.List<RewardEntry>;
  };

  public type MonthlyRewards = {
    seasonId : FootballTypes.SeasonId;
    month : Base.CalendarMonth;
    rewards : List.List<RewardEntry>;
  };

  public type SeasonRewards = {
    seasonId : FootballTypes.SeasonId;
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

  public type WeeklyLeaderboard = {
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
  };

  public type MonthlyLeaderboard = {
    seasonId : FootballTypes.SeasonId;
    month : Base.CalendarMonth;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
    clubId : FootballTypes.ClubId;
  };

  public type SeasonLeaderboard = {
    seasonId : FootballTypes.SeasonId;
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
    seasonId : FootballTypes.SeasonId;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
  };

  public type LoanTimer = {
    timerInfo : Base.TimerInfo;
    playerId : Nat16;
    expires : Int;
  };

  public type DataHashes = {
    dataHashes : [Base.DataHash];
  };

  public type LeagueGameweekStatus = {
    leagueId : FootballTypes.LeagueId;
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
    status : LeaderboardStatus;
  };

  public type LeagueMonthStatus = {
    leagueId : FootballTypes.LeagueId;
    seasonId : FootballTypes.SeasonId;
    month : Base.CalendarMonth;
    status : LeaderboardStatus;
  };

  public type LeagueSeasonStatus = {
    leagueId : FootballTypes.LeagueId;
    seasonId : FootballTypes.SeasonId;
    status : LeaderboardStatus;
  };

  public type AppStatus = {
    onHold : Bool;
    version : Text;
  };

  public type LeaderboardStatus = {
    #NotStarted;
    #Active;
    #Settled;
    #Void;
  };

  public type RewardRates = {
    seasonId : FootballTypes.SeasonId;
    startDate : Int;
    seasonLeaderboardRewardRate : Nat64;
    monthlyLeaderboardRewardRate : Nat64;
    weeklyLeaderboardRewardRate : Nat64;
    mostValuableTeamRewardRate : Nat64;
    highestScoringMatchRewardRate : Nat64;
    allTimeWeeklyHighScoreRewardRate : Nat64;
    allTimeMonthlyHighScoreRewardRate : Nat64;
    allTimeSeasonHighScoreRewardRate : Nat64;
  };

  public type EntryRequirement = {
    #FreeEntry;
    #InviteOnly;
    #PaidEntry;
    #PaidInviteEntry;
  };

  public type TokenInfo = {
    id : TokenId;
    ticker : Text;
    canisterId : Base.CanisterId;
    tokenImageURL : Text;
    fee : Nat;
  };

  public type PaymentChoice = {
    #ICP;
    #FPL;
  };

  public type InviteStatus = {
    #Sent;
    #Accepted;
    #Rejected;
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
    #Leaderboard;
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

  public type MembershipType = {
    #Monthly;
    #Seasonal;
    #Lifetime;
    #Expired;
    #NotClaimed;
    #NotEligible;
  };

  public type ICFCLinkStatus = {
    #PendingVerification;
    #Verified;
  };

  public type MembershipClaim = {
    membershipType : MembershipType;
    claimedOn : Int;
    expiresOn : ?Int;
  };

  public type ICFCProfile = {
    membershipType : MembershipType;
    principalId : Base.PrincipalId;
    linkStatus : ICFCLinkStatus;
    dataHash : Text;
  };
  public type SubApp = {
    #OpenFPL;
    #OpenWSL;
    #JeffBets;
    #TransferKings;
    #FootballGod;
  };

};
