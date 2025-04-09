import List "mo:base/List";
import Ids "mo:waterway-mops/Ids";
import BaseTypes "mo:waterway-mops/BaseTypes";
import ICFCEnums "mo:waterway-mops/ICFCEnums";
import FootballIds "mo:waterway-mops/football/FootballIds";
import FootballDefinitions "mo:waterway-mops/football/FootballDefinitions";
import BaseDefinitions "mo:waterway-mops/BaseDefinitions";
import AppEnums "../enums/app_enums";

module AppTypes {

  public type TokenId = Nat16; // TODO Move

  //Manager types

  public type Manager = {
    principalId : Ids.PrincipalId;
    canisterId : Ids.CanisterId;
    username : Text;
    termsAccepted : Bool;
    profilePicture : ?Blob;
    profilePictureType : Text;
    createDate : Int;
    favouriteClubId : ?FootballIds.ClubId;
    transfersAvailable : Nat8;
    monthlyBonusesAvailable : Nat8;
    bankQuarterMillions : Nat16;
    playerIds : [FootballIds.PlayerId];
    captainId : FootballIds.PlayerId;
    goalGetterGameweek : FootballDefinitions.GameweekNumber;
    goalGetterPlayerId : FootballIds.PlayerId;
    passMasterGameweek : FootballDefinitions.GameweekNumber;
    passMasterPlayerId : FootballIds.PlayerId;
    noEntryGameweek : FootballDefinitions.GameweekNumber;
    noEntryPlayerId : FootballIds.PlayerId;
    teamBoostGameweek : FootballDefinitions.GameweekNumber;
    teamBoostClubId : FootballIds.ClubId;
    safeHandsGameweek : FootballDefinitions.GameweekNumber;
    safeHandsPlayerId : FootballIds.PlayerId;
    captainFantasticGameweek : FootballDefinitions.GameweekNumber;
    captainFantasticPlayerId : FootballIds.PlayerId;
    oneNationGameweek : FootballDefinitions.GameweekNumber;
    oneNationCountryId : Ids.CountryId;
    prospectsGameweek : FootballDefinitions.GameweekNumber;
    braceBonusGameweek : FootballDefinitions.GameweekNumber;
    hatTrickHeroGameweek : FootballDefinitions.GameweekNumber;
    transferWindowGameweek : FootballDefinitions.GameweekNumber;
    history : List.List<FantasyTeamSeason>;
  };

  public type FantasyTeamSeason = {
    seasonId : FootballIds.SeasonId;
    totalPoints : Int16;
    gameweeks : List.List<FantasyTeamSnapshot>;
  };

  public type FantasyTeamSnapshot = {
    principalId : Text;
    username : Text;
    favouriteClubId : ?FootballIds.ClubId;
    monthlyBonusesAvailable : Nat8;
    transfersAvailable : Nat8;
    bankQuarterMillions : Nat16;
    teamValueQuarterMillions : Nat16;
    playerIds : [FootballIds.PlayerId];
    captainId : FootballIds.PlayerId;
    gameweek : FootballDefinitions.GameweekNumber;
    goalGetterGameweek : FootballDefinitions.GameweekNumber;
    goalGetterPlayerId : FootballIds.PlayerId;
    passMasterGameweek : FootballDefinitions.GameweekNumber;
    passMasterPlayerId : FootballIds.PlayerId;
    noEntryGameweek : FootballDefinitions.GameweekNumber;
    noEntryPlayerId : FootballIds.PlayerId;
    teamBoostGameweek : FootballDefinitions.GameweekNumber;
    teamBoostClubId : FootballIds.ClubId;
    safeHandsGameweek : FootballDefinitions.GameweekNumber;
    safeHandsPlayerId : FootballIds.PlayerId;
    captainFantasticGameweek : FootballDefinitions.GameweekNumber;
    captainFantasticPlayerId : FootballIds.PlayerId;
    oneNationGameweek : FootballDefinitions.GameweekNumber;
    oneNationCountryId : Ids.CountryId;
    prospectsGameweek : FootballDefinitions.GameweekNumber;
    braceBonusGameweek : FootballDefinitions.GameweekNumber;
    hatTrickHeroGameweek : FootballDefinitions.GameweekNumber;
    points : Int16;
    monthlyPoints : Int16;
    seasonPoints : Int16;
    transferWindowGameweek : FootballDefinitions.GameweekNumber;
    month : BaseDefinitions.CalendarMonth;
    seasonId : FootballIds.SeasonId;
  };

  public type WeeklyRewards = {
    seasonId : FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    rewards : List.List<RewardEntry>;
  };

  public type MonthlyClubRewards = {
    seasonId : FootballIds.SeasonId;
    month : BaseDefinitions.CalendarMonth;
    clubId : FootballIds.ClubId;
    rewards : List.List<RewardEntry>;
  };

  public type MonthlyRewards = {
    seasonId : FootballIds.SeasonId;
    month : BaseDefinitions.CalendarMonth;
    rewards : List.List<RewardEntry>;
  };

  public type SeasonRewards = {
    seasonId : FootballIds.SeasonId;
    rewards : List.List<RewardEntry>;
  };

  public type RewardsList = {
    rewards : List.List<RewardEntry>;
  };

  public type RewardEntry = {
    principalId : Text;
    rewardType : AppEnums.RewardType;
    position : Nat;
    amount : Nat64;
  };

  public type HighScoreRecord = {
    recordType : AppEnums.RecordType;
    points : Int16;
    createDate : Int;
  };

  public type WeeklyLeaderboard = {
    seasonId : FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
  };

  public type MonthlyLeaderboard = {
    seasonId : FootballIds.SeasonId;
    month : BaseDefinitions.CalendarMonth;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
    clubId : FootballIds.ClubId;
  };

  public type SeasonLeaderboard = {
    seasonId : FootballIds.SeasonId;
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
    seasonId : FootballIds.SeasonId;
    entries : List.List<LeaderboardEntry>;
    totalEntries : Nat;
  };

  public type LoanTimer = {
    timerInfo : BaseTypes.TimerInfo;
    playerId : Nat16;
    expires : Int;
  };

  public type DataHashes = {
    dataHashes : [BaseTypes.DataHash];
  };

  public type LeagueGameweekStatus = {
    leagueId : FootballIds.LeagueId;
    seasonId : FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    status : AppEnums.LeaderboardStatus;
  };

  public type LeagueMonthStatus = {
    leagueId : FootballIds.LeagueId;
    seasonId : FootballIds.SeasonId;
    month : BaseDefinitions.CalendarMonth;
    status : AppEnums.LeaderboardStatus;
  };

  public type LeagueSeasonStatus = {
    leagueId : FootballIds.LeagueId;
    seasonId : FootballIds.SeasonId;
    status : AppEnums.LeaderboardStatus;
  };

  public type AppStatus = {
    onHold : Bool;
    version : Text;
  };

  public type RewardRates = {
    seasonId : FootballIds.SeasonId;
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

  public type TokenInfo = {
    id : TokenId;
    ticker : Text;
    canisterId : Ids.CanisterId;
    tokenImageURL : Text;
    fee : Nat;
  };

  public type MembershipClaim = {
    membershipType : AppEnums.MembershipType;
    purchasedOn : Int;
    expiresOn : ?Int;
  };

  public type ICFCLink = {
    membershipType : AppEnums.MembershipType;
    principalId : Ids.PrincipalId;
    linkStatus : ICFCEnums.ICFCLinkStatus;
    dataHash : Text;
  };

};
