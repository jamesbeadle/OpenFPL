import List "mo:base/List";
import Ids "mo:waterway-mops/base/ids";
import BaseTypes "mo:waterway-mops/base/types";
import AppEnums "mo:waterway-mops/product/wwl/enums";
import ICFCEnums "mo:waterway-mops/product/icfc/enums";
import FootballIds "mo:waterway-mops/domain/football/ids";
import FootballDefinitions "mo:waterway-mops/domain/football/definitions";
import BaseDefinitions "mo:waterway-mops/base/definitions";
import BaseEnums "mo:waterway-mops/base/enums";
import FootballEnums "mo:waterway-mops/domain/football/enums";
import Enums "../enums/app_enums";

module AppTypes {

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
    rewardType : Enums.RewardType;
    position : Nat;
    amount : Nat64;
  };

  public type HighScoreRecord = {
    recordType : Enums.RecordType;
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

  public type DataHashes = {
    dataHashes : [BaseTypes.DataHash];
  };

  public type LeagueGameweekStatus = {
    leagueId : FootballIds.LeagueId;
    seasonId : FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    status : Enums.LeaderboardStatus;
  };

  public type LeagueMonthStatus = {
    leagueId : FootballIds.LeagueId;
    seasonId : FootballIds.SeasonId;
    month : BaseDefinitions.CalendarMonth;
    status : Enums.LeaderboardStatus;
  };

  public type LeagueSeasonStatus = {
    leagueId : FootballIds.LeagueId;
    seasonId : FootballIds.SeasonId;
    status : Enums.LeaderboardStatus;
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

  public type MembershipClaim = {
    membershipType : ICFCEnums.MembershipType;
    purchasedOn : Int;
    expiresOn : ?Int;
  };

  public type ICFCLink = {
    membershipType : ICFCEnums.MembershipType;
    principalId : Ids.PrincipalId;
    linkStatus : AppEnums.LinkStatus;
    dataHash : Text;
  };

  public type LeaderboardPayout = {
    seasonId : FootballIds.SeasonId;
    gameweek : FootballDefinitions.GameweekNumber;
    leaderboard : [LeaderboardPayoutEntry];
    totalEntries : Nat;
    totalEntriesPaid : Nat;
  };

  public type LeaderboardPayoutEntry = {
    appPrincipalId : Ids.PrincipalId;
    rewardAmount : ?Nat64;
    payoutStatus : BaseEnums.PayoutStatus;
    payoutDate : ?Int;
  };

  public type SnapshotPlayer = {
    id : FootballIds.PlayerId;
    position : FootballEnums.PlayerPosition;
    nationality : Ids.CountryId;
    dateOfBirth : Int;
    clubId : FootballIds.ClubId;
    valueQuarterMillions : Nat16;
  };

};
