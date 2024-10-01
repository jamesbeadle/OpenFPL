import T "types";

module DTOs {

  public type ProfileDTO = {
    principalId : Text;
    username : Text;
    termsAccepted : Bool;
    profilePicture : ?Blob;
    profilePictureType : Text;
    favouriteClubId : ?T.ClubId;
    createDate : Int;
  };

  public type PickTeamDTO = {
    principalId : Text;
    username : Text;
    transfersAvailable : Nat8;
    monthlyBonusesAvailable : Nat8;
    bankQuarterMillions : Nat16;
    playerIds : [T.PlayerId];
    captainId : T.PlayerId;
    goalGetterGameweek : T.GameweekNumber;
    goalGetterPlayerId : T.PlayerId;
    passMasterGameweek : T.GameweekNumber;
    passMasterPlayerId : T.PlayerId;
    noEntryGameweek : T.GameweekNumber;
    noEntryPlayerId : T.PlayerId;
    teamBoostGameweek : T.GameweekNumber;
    teamBoostClubId : T.ClubId;
    safeHandsGameweek : T.GameweekNumber;
    safeHandsPlayerId : T.PlayerId;
    captainFantasticGameweek : T.GameweekNumber;
    captainFantasticPlayerId : T.PlayerId;
    countrymenGameweek : T.GameweekNumber;
    countrymenCountryId : T.CountryId;
    prospectsGameweek : T.GameweekNumber;
    braceBonusGameweek : T.GameweekNumber;
    hatTrickHeroGameweek : T.GameweekNumber;
    transferWindowGameweek : T.GameweekNumber;
    canisterId: T.CanisterId;
  };

  public type ManagerDTO = {
    principalId : Text;
    username : Text;
    profilePicture : ?Blob;
    favouriteClubId : ?T.ClubId;
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
    seasonId : T.SeasonId;
    gameweek : T.GameweekNumber;
    limit : Nat;
    offset : Nat;
    searchTerm : Text;
  };

  public type WeeklyLeaderboardDTO = {
    seasonId : T.SeasonId;
    gameweek : T.GameweekNumber;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type MonthlyLeaderboardDTO = {
    seasonId : T.SeasonId;
    month : Nat8;
    clubId: T.ClubId;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type GetMonthlyLeaderboardDTO = {
    seasonId : T.SeasonId;
    clubId : T.ClubId;
    month : T.CalendarMonth;
    limit : Nat;
    offset : Nat;
    searchTerm : Text;
  };

  public type GetSeasonLeaderboardDTO = {
    seasonId : T.SeasonId;
    limit : Nat;
    offset : Nat;
    searchTerm : Text;
  };

  public type SeasonLeaderboardDTO = {
    seasonId : T.SeasonId;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type ClubFilterDTO = {
    leagueId: T.FootballLeagueId;
    clubId: T.ClubId;
  };

  public type GameweekFiltersDTO = {
    leagueId: T.FootballLeagueId;
    seasonId : T.SeasonId;
    gameweek : T.GameweekNumber;
  };

  public type GetPlayerDetailsDTO = {
    leagueId: T.FootballLeagueId;
    playerId : T.PlayerId;
    seasonId : T.SeasonId;
  };

  public type UsernameFilterDTO = {
    username : Text
    };  

    public type SystemStateDTO = {
      calculationGameweek : T.GameweekNumber;
      calculationMonth : T.CalendarMonth;
      calculationSeasonId : T.SeasonId;
      pickTeamGameweek : T.GameweekNumber;
      pickTeamSeasonId : T.SeasonId;
      transferWindowActive : Bool;
      onHold : Bool;
      seasonActive: Bool;
      version: Text;
    };

  public type RevaluePlayerUpDTO = {
    leagueId: T.FootballLeagueId;
    playerId : T.PlayerId;
    seasonId: T.SeasonId;
    gameweek: T.GameweekNumber;
  };

  public type RevaluePlayerDownDTO = {
    leagueId: T.FootballLeagueId;
    playerId : T.PlayerId;
    seasonId: T.SeasonId;
    gameweek: T.GameweekNumber;
  };

  public type SubmitFixtureDataDTO = {
    seasonId : T.SeasonId;
    gameweek : T.GameweekNumber;
    month: T.CalendarMonth;
    fixtureId : T.FixtureId;
    playerEventData : [T.PlayerEventData];
    leagueId: T.FootballLeagueId;
  };

  public type AddInitialFixturesDTO = {
    seasonId : T.SeasonId;
    seasonFixtures : [DTOs.FixtureDTO];
  };

  public type MoveFixtureDTO = {
    fixtureId : T.FixtureId;
    updatedFixtureGameweek : T.GameweekNumber;
    updatedFixtureDate : Int;
  };

  public type PostponeFixtureDTO = {
    fixtureId : T.FixtureId;
  };

  public type RescheduleFixtureDTO = {
    postponedFixtureId : T.FixtureId;
    updatedFixtureGameweek : T.GameweekNumber;
    updatedFixtureDate : Int;
  };

  public type LoanPlayerDTO = {
    leagueId: T.FootballLeagueId;
    seasonId: T.SeasonId;
    gameweek: T.GameweekNumber;
    playerId : T.PlayerId;
    loanLeagueId: T.FootballLeagueId;
    loanClubId : T.ClubId;
    loanEndDate : Int;
  };

  public type TransferPlayerDTO = {
    leagueId: T.FootballLeagueId;
    clubId: T.ClubId;
    playerId : T.PlayerId;
    newLeagueId: T.FootballLeagueId;
    newClubId : T.ClubId;
    seasonId: T.SeasonId;
    gameweek: T.GameweekNumber;
    newShirtNumber: Nat8;
  };

  public type RecallPlayerDTO = {
    leagueId: T.FootballLeagueId;
    playerId : T.PlayerId;
  };

  public type CreatePlayerDTO = {
    leagueId: T.FootballLeagueId;
    clubId : T.ClubId;
    position : T.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : T.CountryId;
    gender: T.Gender;
  };

  public type UpdatePlayerDTO = {
    leagueId: T.FootballLeagueId;
    playerId : T.PlayerId;
    position : T.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    dateOfBirth : Int;
    nationality : T.CountryId;
  };

  public type SetPlayerInjuryDTO = {
    leagueId: T.FootballLeagueId;
    playerId : T.PlayerId;
    description : Text;
    expectedEndDate : Int;
  };

  public type RetirePlayerDTO = {
    leagueId: T.FootballLeagueId;
    playerId : T.PlayerId;
    retirementDate : Int;
  };

  public type UnretirePlayerDTO = {
    leagueId: T.FootballLeagueId;
    playerId : T.PlayerId;
  };

  public type UpdateClubDTO = {
    clubId : T.ClubId;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : T.ShirtType;
  };

  public type PromoteNewClubDTO = {
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : T.ShirtType;
  };

  public type PlayerRatingsDTO = {
    players : [T.Player];
    totalEntries : Nat16;
  };

  public type PlayerDTO = {
    id : Nat16;
    clubId : T.ClubId;
    position : T.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : T.CountryId;
    totalPoints : Int16;
    status : T.PlayerStatus;
  };

  public type PlayerScoreDTO = {
    id : Nat16;
    points : Int16;
    clubId : T.ClubId;
    goalsScored : Int16;
    goalsConceded : Int16;
    position : T.PlayerPosition;
    nationality : T.CountryId;
    dateOfBirth : Int;
    saves : Int16;
    assists : Int16;
    events : [T.PlayerEventData];
  };

  public type PlayerPointsDTO = {
    id : Nat16;
    gameweek : T.GameweekNumber;
    points : Int16;
    clubId : T.ClubId;
    position : T.PlayerPosition;
    events : [T.PlayerEventData];
  };

  public type PlayerDetailDTO = {
    id : T.PlayerId;
    clubId : T.ClubId;
    position : T.PlayerPosition;
    firstName : Text;
    lastName : Text;
    shirtNumber : Nat8;
    valueQuarterMillions : Nat16;
    dateOfBirth : Int;
    nationality : T.CountryId;
    seasonId : T.SeasonId;
    gameweeks : [PlayerGameweekDTO];
    valueHistory : [T.ValueHistory];
    status : T.PlayerStatus;
    parentClubId : T.ClubId;
    latestInjuryEndDate : Int;
    injuryHistory : [T.InjuryHistory];
    retirementDate : Int;
  };

  public type PlayerGameweekDTO = {
    number : Nat8;
    events : [T.PlayerEventData];
    points : Int16;
    fixtureId : T.FixtureId;
  };

  public type LeaderboardEntryDTO = {
    position : Int;
    positionText : Text;
    username : Text;
    principalId : Text;
    points : Int16;
  };

  public type SeasonDTO = {
    id : T.SeasonId;
    name : Text;
    year : Nat16;
  };

  public type FixtureDTO = {
    id : Nat32;
    seasonId : T.SeasonId;
    gameweek : T.GameweekNumber;
    kickOff : Int;
    homeClubId : T.ClubId;
    awayClubId : T.ClubId;
    homeGoals : Nat8;
    awayGoals : Nat8;
    status : T.FixtureStatusType;
    highestScoringPlayerId : Nat16;
    events : [T.PlayerEventData];
  };

  public type UpdateSystemStateDTO = {
    pickTeamSeasonId : T.SeasonId;
    pickTeamGameweek : T.GameweekNumber;
    calculationGameweek : T.GameweekNumber;
    calculationMonth : T.CalendarMonth;
    calculationSeasonId : T.SeasonId;
    transferWindowActive : Bool;
    onHold : Bool;
  };

  public type UpdateFixtureDTO = {
    seasonId : T.SeasonId;
    fixtureId : T.FixtureId;
    gameweek : T.GameweekNumber;
    kickOff : Int;
    status : T.FixtureStatusType;
  };

  public type ClubDTO = {
    id : T.ClubId;
    name : Text;
    friendlyName : Text;
    primaryColourHex : Text;
    secondaryColourHex : Text;
    thirdColourHex : Text;
    abbreviatedName : Text;
    shirtType : T.ShirtType;
  };

  public type CountryDTO = {
    id : T.CountryId;
    name : Text;
    code : Text;
  };

  public type DataHashDTO = {
    category : Text;
    hash : Text;
  };

  public type TeamValueLeaderboard = {
    seasonId : T.SeasonId;
    entries : [T.LeaderboardEntry];
    totalEntries : Nat;
  };

  public type WeeklyCanisterDTO = {
    canister : T.WeeklyLeaderboardCanister;
    cycles : Nat;
  };

  public type MonthlyCanisterDTO = {
    canister : T.MonthlyLeaderboardsCanister;
    cycles : Nat;
  };

  public type SeasonCanisterDTO = {
    canister : T.SeasonLeaderboardCanister;
    cycles : Nat;
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

  public type CanisterDTO = {
    canisterId: T.CanisterId;
    cycles: Nat;
    lastTopup: Int;
    canister_type: T.CanisterType;
  };

  public type RewardPoolDTO = {
    seasonId: T.SeasonId;
    rewardPool: T.RewardPool;
  };

  public type TopupDTO = {
    canisterId: Text;
    toppedUpOn: Int;
    topupAmount: Nat;
  };

  public type LeagueMemberDTO = {
    principalId : T.PrincipalId;
    username: Text;
    added: Int;
  };

  public type NewTokenDTO = {
    canisterId: T.CanisterId;
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
    canisterId: T.CanisterId;
    managerId: T.PrincipalId;
  };

  public type UpdateLeaguePictureDTO = {
     canisterId: T.CanisterId;
     picture: ?Blob;
  };

  public type UpdateLeagueBannerDTO = {
    canisterId: T.CanisterId;
    banner: ?Blob;
  };

  public type UpdateLeagueNameDTO = {
    canisterId: T.CanisterId;
    name: Text;
  };

  public type GetLeagueMembersDTO = {
    canisterId: T.CanisterId;
    limit : Nat;
    offset : Nat;
  };

  public type UpdateTeamSelectionDTO = {
    playerIds : [T.PlayerId];
    captainId : T.PlayerId;
    goalGetterGameweek : T.GameweekNumber;
    goalGetterPlayerId : T.PlayerId;
    passMasterGameweek : T.GameweekNumber;
    passMasterPlayerId : T.PlayerId;
    noEntryGameweek : T.GameweekNumber;
    noEntryPlayerId : T.PlayerId;
    teamBoostGameweek : T.GameweekNumber;
    teamBoostClubId : T.ClubId;
    safeHandsGameweek : T.GameweekNumber;
    safeHandsPlayerId : T.PlayerId;
    captainFantasticGameweek : T.GameweekNumber;
    captainFantasticPlayerId : T.PlayerId;
    countrymenGameweek : T.GameweekNumber;
    countrymenCountryId : T.CountryId;
    prospectsGameweek : T.GameweekNumber;
    braceBonusGameweek : T.GameweekNumber;
    hatTrickHeroGameweek : T.GameweekNumber;
    transferWindowGameweek : T.GameweekNumber;
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
    favouriteClubId : T.ClubId;
  };

  public type FavouriteClubUpdateDTO = {
    principalId : Text;
    favouriteClubId : T.ClubId;
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
    favouriteClubId : T.ClubId;
    profilePicture : ?Blob;
    teamSelection: UpdateTeamSelectionDTO;
  };

  public type CanisterInfoDTO = {
    canisterId: T.CanisterId;
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
    seasonId: T.SeasonId;
    rewardPool: T.RewardPool;
  };

  public type GetTopupsDTO = {
    limit : Nat;
    offset : Nat;
    entries: [TopupDTO];
    totalEntries: Nat;
  };

  public type GetSystemLogDTO = {
    limit : Nat;
    offset : Nat;
    dateStart : Int;
    dateEnd: Int;
    eventType: T.EventLogEntryType;
    entries: [T.EventLogEntry];
    totalEntries: Nat;
  };

  public type LogStatusDTO = {
    message: Text;
  };

  public type GetFantasyTeamSnapshotDTO = {
    managerPrincipalId: T.PrincipalId;
    seasonId: T.SeasonId;
    gameweek: T.GameweekNumber;
  };


  public type FantasyTeamSnapshotDTO = {
    principalId : Text;
    username : Text;
    favouriteClubId : T.ClubId;
    monthlyBonusesAvailable : Nat8;
    transfersAvailable : Nat8;
    bankQuarterMillions : Nat16;
    teamValueQuarterMillions : Nat16;
    playerIds : [T.PlayerId];
    captainId : T.PlayerId;
    gameweek : T.GameweekNumber;
    goalGetterGameweek : T.GameweekNumber;
    goalGetterPlayerId : T.PlayerId;
    passMasterGameweek : T.GameweekNumber;
    passMasterPlayerId : T.PlayerId;
    noEntryGameweek : T.GameweekNumber;
    noEntryPlayerId : T.PlayerId;
    teamBoostGameweek : T.GameweekNumber;
    teamBoostClubId : T.ClubId;
    safeHandsGameweek : T.GameweekNumber;
    safeHandsPlayerId : T.PlayerId;
    captainFantasticGameweek : T.GameweekNumber;
    captainFantasticPlayerId : T.PlayerId;
    countrymenGameweek : T.GameweekNumber;
    countrymenCountryId : T.CountryId;
    prospectsGameweek : T.GameweekNumber;
    braceBonusGameweek : T.GameweekNumber;
    hatTrickHeroGameweek : T.GameweekNumber;
    points : Int16;
    monthlyPoints : Int16;
    seasonPoints : Int16;
    transferWindowGameweek : T.GameweekNumber;
    month : T.CalendarMonth;
    seasonId: T.SeasonId;
  };

  public type GetLoanedPlayersDTO = {
    loanClubId: T.ClubId;
  };

};
