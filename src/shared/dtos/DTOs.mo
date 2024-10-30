import Base "../types/base_types";
import T "../types/app_types";
import FootballTypes "../types/football_types";

module DTOs {

  public type ProfileDTO = {
    principalId : Text;
    username : Text;
    termsAccepted : Bool;
    profilePicture : ?Blob;
    profilePictureType : Text;
    favouriteClubId : ?FootballTypes.ClubId;
    createDate : Int;
  };

  public type PickTeamDTO = {
    principalId : Text;
    username : Text;
    transfersAvailable : Nat8;
    monthlyBonusesAvailable : Nat8;
    bankQuarterMillions : Nat16;
    playerIds : [FootballTypes.ClubId];
    captainId : FootballTypes.ClubId;
    goalGetterGameweek : FootballTypes.GameweekNumber;
    goalGetterPlayerId : FootballTypes.ClubId;
    passMasterGameweek : FootballTypes.GameweekNumber;
    passMasterPlayerId : FootballTypes.ClubId;
    noEntryGameweek : FootballTypes.GameweekNumber;
    noEntryPlayerId : FootballTypes.ClubId;
    teamBoostGameweek : FootballTypes.GameweekNumber;
    teamBoostClubId : FootballTypes.ClubId;
    safeHandsGameweek : FootballTypes.GameweekNumber;
    safeHandsPlayerId : FootballTypes.ClubId;
    captainFantasticGameweek : FootballTypes.GameweekNumber;
    captainFantasticPlayerId : FootballTypes.ClubId;
    oneNationGameweek : FootballTypes.GameweekNumber;
    oneNationCountryId : Base.CountryId;
    prospectsGameweek : FootballTypes.GameweekNumber;
    braceBonusGameweek : FootballTypes.GameweekNumber;
    hatTrickHeroGameweek : FootballTypes.GameweekNumber;
    transferWindowGameweek : FootballTypes.GameweekNumber;
    canisterId: Base.CanisterId;
    firstGameweek: Bool;
  };

  public type ManagerDTO = {
    principalId : Text;
    username : Text;
    profilePicture : ?Blob;
    favouriteClubId : ?FootballTypes.ClubId;
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

  public type GetWeeklyLeaderboardDTO = {
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
    limit : Nat;
    offset : Nat;
    searchTerm : Text;
  };

  public type WeeklyLeaderboardDTO = {
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type MonthlyLeaderboardDTO = {
    seasonId : FootballTypes.SeasonId;
    month : Nat8;
    clubId: FootballTypes.ClubId;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type GetMonthlyLeaderboardDTO = {
    seasonId : FootballTypes.SeasonId;
    clubId : FootballTypes.ClubId;
    month : Base.CalendarMonth;
    limit : Nat;
    offset : Nat;
    searchTerm : Text;
  };

  public type GetSeasonLeaderboardDTO = {
    seasonId : FootballTypes.SeasonId;
    limit : Nat;
    offset : Nat;
    searchTerm : Text;
  };

  public type SeasonLeaderboardDTO = {
    seasonId : FootballTypes.SeasonId;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type ClubFilterDTO = {
    leagueId: FootballTypes.LeagueId;
    clubId: FootballTypes.ClubId;
  };

  public type GameweekFiltersDTO = {
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
  };

  public type GetPlayerDetailsDTO = {
    playerId : FootballTypes.ClubId;
    seasonId : FootballTypes.SeasonId;
  };

  public type UsernameFilterDTO = {
    username : Text
  };  

  public type SystemStateDTO = {
    calculationGameweek : FootballTypes.GameweekNumber;
    calculationMonth : Base.CalendarMonth;
    calculationSeasonId : FootballTypes.SeasonId;
    pickTeamGameweek : FootballTypes.GameweekNumber;
    pickTeamSeasonId : FootballTypes.SeasonId;
    pickTeamMonth : Base.CalendarMonth;
    transferWindowActive : Bool;
    onHold : Bool;
    seasonActive: Bool;
    version: Text;
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

  public type PlayerRatingsDTO = {
    players : [FootballTypes.Player];
    totalEntries : Nat16;
  };

  public type PlayerDTO = {
    id : Nat16;
    clubId : FootballTypes.ClubId;
    position : FootballTypes.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Base.CountryId;
    status : FootballTypes.PlayerStatus;
  };

  public type SnapshotPlayerDTO = {
    id : Nat16;
    clubId : FootballTypes.ClubId;
    position : FootballTypes.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Base.CountryId;
    status : FootballTypes.PlayerStatus;
    totalPoints: Int;
  };

  public type PlayerScoreDTO = {
    id : Nat16;
    points : Int16;
    clubId : FootballTypes.ClubId;
    goalsScored : Int16;
    goalsConceded : Int16;
    position : FootballTypes.PlayerPosition;
    nationality : Base.CountryId;
    dateOfBirth : Int;
    saves : Int16;
    assists : Int16;
    events : [FootballTypes.PlayerEventData];
  };

  public type PlayerPointsDTO = {
    id : Nat16;
    gameweek : FootballTypes.GameweekNumber;
    points : Int16;
    clubId : FootballTypes.ClubId;
    position : FootballTypes.PlayerPosition;
    events : [FootballTypes.PlayerEventData];
  };

  public type PlayerDetailDTO = {
    id : FootballTypes.ClubId;
    clubId : FootballTypes.ClubId;
    position : FootballTypes.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : Base.CountryId;
    seasonId : FootballTypes.SeasonId;
    gameweeks : [PlayerGameweekDTO];
    valueHistory : [FootballTypes.ValueHistory];
    status : FootballTypes.PlayerStatus;
    parentClubId : FootballTypes.ClubId;
    latestInjuryEndDate : Int;
    injuryHistory : [FootballTypes.InjuryHistory];
    retirementDate : Int;
  };

  public type PlayerGameweekDTO = {
    number : Nat8;
    events : [FootballTypes.PlayerEventData];
    points : Int16;
    fixtureId : FootballTypes.FixtureId;
  };

  public type LeaderboardEntryDTO = {
    position : Int;
    positionText : Text;
    username : Text;
    principalId : Text;
    points : Int16;
  };

  public type SeasonDTO = {
    id : FootballTypes.SeasonId;
    name : Text;
    year : Nat16;
  };

  public type FixtureDTO = {
    id : Nat32;
    seasonId : FootballTypes.SeasonId;
    gameweek : FootballTypes.GameweekNumber;
    kickOff : Int;
    homeClubId : FootballTypes.ClubId;
    awayClubId : FootballTypes.ClubId;
    homeGoals : Nat8;
    awayGoals : Nat8;
    status : FootballTypes.FixtureStatusType;
    highestScoringPlayerId : Nat16;
    events : [FootballTypes.PlayerEventData];
  };

  public type UpdateFixtureDTO = {
    seasonId : FootballTypes.SeasonId;
    fixtureId : FootballTypes.FixtureId;
    gameweek : FootballTypes.GameweekNumber;
    kickOff : Int;
    status : FootballTypes.FixtureStatusType;
  };

  public type FootballLeagueDTO = {
    id: FootballTypes.LeagueId;
    name: Text;
    abbreviation: Text;
    teamCount: Nat8;
    relatedGender: Base.Gender;
    governingBody: Text;
    formed: Int;
    countryId: Base.CountryId;
    logo: Blob;
  };

  public type ClubDTO = {
    id : FootballTypes.ClubId;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : FootballTypes.ShirtType;
  };

  public type CountryDTO = {
    id : Base.CountryId;
    name : Text;
    code : Text;
  };

  public type DataHashDTO = {
    category : Text;
    hash : Text;
  };

  public type TeamValueLeaderboard = {
    seasonId : FootballTypes.SeasonId;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type CanisterDTO = {
    canister : T.LeaderboardCanister;
  };

  public type ManagerCanisterDTO = {
    canisterId : Text;
    cycles : Nat;
  };

  public type TimerDTO = {
    id : Int;
    triggerTime : Int;
    callbackName : Text;
  };

  public type RewardPoolDTO = {
    seasonId: FootballTypes.SeasonId;
    rewardPool: T.RewardPool;
  };

  public type TopupDTO = {
    canisterId: Text;
    toppedUpOn: Int;
    topupAmount: Nat;
  };

  public type LeagueMemberDTO = {
    principalId : Base.PrincipalId;
    username: Text;
    added: Int;
  };

  public type NewTokenDTO = {
    canisterId: Base.CanisterId;
    ticker: Text;
    tokenImageURL: Text;
    fee: Nat;
  };

  type CoinIdInfo = {coinId: Nat; coinSubId: Nat};
  public type ICPCoinsResponse = {coinIdInfo: CoinIdInfo; pairName: Text; price: Float};

  public type PaginationFiltersDTO = {
    limit : Nat;
    offset : Nat;
  };

  public type LeagueInviteDTO = {
    canisterId: Base.CanisterId;
    managerId: Base.PrincipalId;
  };

  public type UpdateLeaguePictureDTO = {
     canisterId: Base.CanisterId;
     picture: ?Blob;
  };

  public type UpdateLeagueBannerDTO = {
    canisterId: Base.CanisterId;
    banner: ?Blob;
  };

  public type UpdateLeagueNameDTO = {
    canisterId: Base.CanisterId;
    name: Text;
  };

  public type GetLeagueMembersDTO = {
    canisterId: Base.CanisterId;
    limit : Nat;
    offset : Nat;
  };

  public type UpdateTeamSelectionDTO = {
    playerIds : [FootballTypes.ClubId];
    captainId : FootballTypes.ClubId;
    goalGetterGameweek : FootballTypes.GameweekNumber;
    goalGetterPlayerId : FootballTypes.ClubId;
    passMasterGameweek : FootballTypes.GameweekNumber;
    passMasterPlayerId : FootballTypes.ClubId;
    noEntryGameweek : FootballTypes.GameweekNumber;
    noEntryPlayerId : FootballTypes.ClubId;
    teamBoostGameweek : FootballTypes.GameweekNumber;
    teamBoostClubId : FootballTypes.ClubId;
    safeHandsGameweek : FootballTypes.GameweekNumber;
    safeHandsPlayerId : FootballTypes.ClubId;
    captainFantasticGameweek : FootballTypes.GameweekNumber;
    captainFantasticPlayerId : FootballTypes.ClubId;
    oneNationGameweek : FootballTypes.GameweekNumber;
    oneNationCountryId : Base.CountryId;
    prospectsGameweek : FootballTypes.GameweekNumber;
    braceBonusGameweek : FootballTypes.GameweekNumber;
    hatTrickHeroGameweek : FootballTypes.GameweekNumber;
    transferWindowGameweek : FootballTypes.GameweekNumber;
    username: Text;
  };

  public type TeamUpdateDTO = {
    principalId : Text;
    updatedTeamSelection: UpdateTeamSelectionDTO;
  };

  public type UpdateUsernameDTO = {
    username : Text;
  };

  public type UsernameUpdateDTO = {
    principalId : Text;
    updatedUsername: UpdateUsernameDTO;
  };

  public type UpdateFavouriteClubDTO = {
    favouriteClubId : FootballTypes.ClubId;
  };

  public type FavouriteClubUpdateDTO = {
    principalId : Text;
    favouriteClubId : FootballTypes.ClubId;
  };

  public type UpdateProfilePictureDTO = {
    profilePicture : Blob;
    extension : Text;
  };

  public type ProfilePictureUpdateDTO = {
    principalId : Text;
    updatedProfilePicture: UpdateProfilePictureDTO;
  };

  public type AddNewManagerDTO = {
    principalId : Text;
    username : Text;
    favouriteClubId : FootballTypes.ClubId;
    profilePicture : ?Blob;
    teamSelection: UpdateTeamSelectionDTO;
  };

  public type CanisterInfoDTO = {
    canisterId: Base.CanisterId;
    lastTopup: Int;
    cyclesBalance: Nat64;
  };

  public type GetCanistersDTO = {
    limit : Nat;
    offset : Nat;
    entries: [CanisterDTO];
    totalEntries: Nat;
    canisterTypeFilter: T.CanisterType;
  };

  public type GetTimersDTO = {
    limit : Nat;
    offset : Nat;
    entries: [TimerDTO];
    totalEntries: Nat;
    timerTypeFilter: T.TimerType;
  };

  public type GetRewardPoolDTO = {
    seasonId: FootballTypes.SeasonId;
    rewardPool: T.RewardPool;
  };

  public type GetFantasyTeamSnapshotDTO = {
    managerPrincipalId: Base.PrincipalId;
    seasonId: FootballTypes.SeasonId;
    gameweek: FootballTypes.GameweekNumber;
  };


  public type FantasyTeamSnapshotDTO = {
    principalId : Text;
    username : Text;
    favouriteClubId : FootballTypes.ClubId;
    monthlyBonusesAvailable : Nat8;
    transfersAvailable : Nat8;
    bankQuarterMillions : Nat16;
    teamValueQuarterMillions : Nat16;
    playerIds : [FootballTypes.ClubId];
    captainId : FootballTypes.ClubId;
    gameweek : FootballTypes.GameweekNumber;
    goalGetterGameweek : FootballTypes.GameweekNumber;
    goalGetterPlayerId : FootballTypes.ClubId;
    passMasterGameweek : FootballTypes.GameweekNumber;
    passMasterPlayerId : FootballTypes.ClubId;
    noEntryGameweek : FootballTypes.GameweekNumber;
    noEntryPlayerId : FootballTypes.ClubId;
    teamBoostGameweek : FootballTypes.GameweekNumber;
    teamBoostClubId : FootballTypes.ClubId;
    safeHandsGameweek : FootballTypes.GameweekNumber;
    safeHandsPlayerId : FootballTypes.ClubId;
    captainFantasticGameweek : FootballTypes.GameweekNumber;
    captainFantasticPlayerId : FootballTypes.ClubId;
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
    seasonId: FootballTypes.SeasonId;
  };

  public type GetLoanedPlayersDTO = {
    loanClubId: FootballTypes.ClubId;
  };

  public type SystemEnvironmentDTO = {
    leagueId: FootballTypes.LeagueId;
    seasonId: FootballTypes.SeasonId;
  };

  public type SystemEventDTO = {
      eventId: Nat;
      eventTime: Int;
      eventType: Base.LogEntryType;
      eventTitle: Text;
      eventDetail: Text;
  };
};
