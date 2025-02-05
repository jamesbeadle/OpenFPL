export const idlFactory = ({ IDL }) => {
  const GameweekNumber = IDL.Nat8;
  const Error = IDL.Variant({
    MoreThan2PlayersFromClub: IDL.Null,
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    DuplicatePlayerInTeam: IDL.Null,
    InvalidBonuses: IDL.Null,
    TooManyTransfers: IDL.Null,
    NotFound: IDL.Null,
    NumberPerPositionError: IDL.Null,
    TeamOverspend: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidGameweek: IDL.Null,
    SelectedCaptainNotInTeam: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    CanisterCreateError: IDL.Null,
    Not11Players: IDL.Null,
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const ClubId = IDL.Nat16;
  const CreateManagerDTO = IDL.Record({
    username: IDL.Text,
    favouriteClubId: IDL.Opt(ClubId),
  });
  const Result_15 = IDL.Variant({ ok: IDL.Text, err: Error });
  const RewardRatesDTO = IDL.Record({
    monthlyLeaderboardRewardRate: IDL.Nat64,
    allTimeSeasonHighScoreRewardRate: IDL.Nat64,
    highestScoringMatchRewardRate: IDL.Nat64,
    seasonLeaderboardRewardRate: IDL.Nat64,
    mostValuableTeamRewardRate: IDL.Nat64,
    allTimeMonthlyHighScoreRewardRate: IDL.Nat64,
    weeklyLeaderboardRewardRate: IDL.Nat64,
    allTimeWeeklyHighScoreRewardRate: IDL.Nat64,
  });
  const Result_14 = IDL.Variant({ ok: RewardRatesDTO, err: Error });
  const AppStatusDTO = IDL.Record({
    version: IDL.Text,
    onHold: IDL.Bool,
  });
  const Result_7 = IDL.Variant({ ok: AppStatusDTO, err: Error });
  const CanisterType = IDL.Variant({
    SNS: IDL.Null,
    Leaderboard: IDL.Null,
    Dapp: IDL.Null,
    Archive: IDL.Null,
    Manager: IDL.Null,
  });
  const GetCanistersDTO = IDL.Record({ canisterType: CanisterType });
  const CanisterId = IDL.Text;
  const CanisterTopup = IDL.Record({
    topupTime: IDL.Int,
    canisterId: CanisterId,
    cyclesAmount: IDL.Nat,
  });
  const CanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    topups: IDL.Vec(CanisterTopup),
    computeAllocation: IDL.Nat,
    canisterId: CanisterId,
  });
  const Result_13 = IDL.Variant({ ok: IDL.Vec(CanisterDTO), err: Error });
  const CountryId = IDL.Nat16;
  const TeamSelectionDTO = IDL.Record({
    playerIds: IDL.Vec(ClubId),
    username: IDL.Text,
    goalGetterPlayerId: ClubId,
    oneNationCountryId: CountryId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    oneNationGameweek: GameweekNumber,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    bankQuarterMillions: IDL.Nat16,
    noEntryPlayerId: ClubId,
    safeHandsPlayerId: ClubId,
    braceBonusGameweek: GameweekNumber,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    firstGameweek: IDL.Bool,
    captainFantasticPlayerId: ClubId,
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: ClubId,
    captainId: ClubId,
    canisterId: CanisterId,
    monthlyBonusesAvailable: IDL.Nat8,
  });
  const Result_12 = IDL.Variant({ ok: TeamSelectionDTO, err: Error });
  const DataHashDTO = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_11 = IDL.Variant({ ok: IDL.Vec(DataHashDTO), err: Error });
  const SeasonId = IDL.Nat16;
  const PrincipalId = IDL.Text;
  const GetManagerGameweekDTO = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    principalId: PrincipalId,
  });
  const PlayerId = IDL.Nat16;
  const CalendarMonth = IDL.Nat8;
  const ManagerGameweekDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    month: CalendarMonth,
    teamValueQuarterMillions: IDL.Nat16,
    username: IDL.Text,
    goalGetterPlayerId: PlayerId,
    oneNationCountryId: CountryId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    oneNationGameweek: GameweekNumber,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    bankQuarterMillions: IDL.Nat16,
    noEntryPlayerId: PlayerId,
    monthlyPoints: IDL.Int16,
    safeHandsPlayerId: PlayerId,
    seasonId: SeasonId,
    braceBonusGameweek: GameweekNumber,
    favouriteClubId: IDL.Opt(ClubId),
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    gameweek: GameweekNumber,
    seasonPoints: IDL.Int16,
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
    points: IDL.Int16,
    monthlyBonusesAvailable: IDL.Nat8,
  });
  const Result_10 = IDL.Variant({ ok: ManagerGameweekDTO, err: Error });
  const Result_9 = IDL.Variant({ ok: IDL.Vec(CanisterId), err: Error });
  const GetManagerDTO = IDL.Record({
    month: CalendarMonth,
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    principalId: PrincipalId,
  });
  const ManagerDTO = IDL.Record({
    username: IDL.Text,
    weeklyPosition: IDL.Int,
    createDate: IDL.Int,
    monthlyPoints: IDL.Int16,
    weeklyPoints: IDL.Int16,
    weeklyPositionText: IDL.Text,
    gameweeks: IDL.Vec(ManagerGameweekDTO),
    favouriteClubId: IDL.Opt(ClubId),
    monthlyPosition: IDL.Int,
    seasonPosition: IDL.Int,
    monthlyPositionText: IDL.Text,
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    seasonPoints: IDL.Int16,
    profilePictureType: IDL.Text,
    principalId: IDL.Text,
    seasonPositionText: IDL.Text,
  });
  const Result_1 = IDL.Variant({ ok: ManagerDTO, err: Error });
  const GetSnapshotPlayersDTO = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
  });
  const PlayerStatus = IDL.Variant({
    OnLoan: IDL.Null,
    Active: IDL.Null,
    FreeAgent: IDL.Null,
    Retired: IDL.Null,
  });
  const LeagueId = IDL.Nat16;
  const PlayerPosition = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null,
  });
  const PlayerDTO = IDL.Record({
    id: IDL.Nat16,
    status: PlayerStatus,
    clubId: ClubId,
    parentClubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    currentLoanEndDate: IDL.Int,
    shirtNumber: IDL.Nat8,
    parentLeagueId: LeagueId,
    position: PlayerPosition,
    lastName: IDL.Text,
    leagueId: LeagueId,
    firstName: IDL.Text,
  });
  const ProfileDTO = IDL.Record({
    username: IDL.Text,
    termsAccepted: IDL.Bool,
    createDate: IDL.Int,
    favouriteClubId: IDL.Opt(ClubId),
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    profilePictureType: IDL.Text,
    principalId: IDL.Text,
  });
  const Result_8 = IDL.Variant({ ok: ProfileDTO, err: Error });
  const Result_6 = IDL.Variant({ ok: IDL.Nat, err: Error });
  const Result_5 = IDL.Variant({ ok: IDL.Vec(PlayerDTO), err: Error });
  const Result_4 = IDL.Variant({
    ok: IDL.Vec(
      IDL.Tuple(SeasonId, IDL.Vec(IDL.Tuple(GameweekNumber, CanisterId))),
    ),
    err: Error,
  });
  const GetWeeklyLeaderboardDTO = IDL.Record({
    offset: IDL.Nat,
    seasonId: SeasonId,
    limit: IDL.Nat,
    searchTerm: IDL.Text,
    gameweek: GameweekNumber,
  });
  const LeaderboardEntryDTO = IDL.Record({
    username: IDL.Text,
    positionText: IDL.Text,
    position: IDL.Nat,
    principalId: IDL.Text,
    points: IDL.Int16,
  });
  const WeeklyLeaderboardDTO = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntryDTO),
    gameweek: GameweekNumber,
  });
  const Result_3 = IDL.Variant({ ok: WeeklyLeaderboardDTO, err: Error });
  const GetWeeklyRewardsDTO = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
  });
  const RewardType = IDL.Variant({
    MonthlyLeaderboard: IDL.Null,
    MostValuableTeam: IDL.Null,
    MonthlyATHScore: IDL.Null,
    WeeklyATHScore: IDL.Null,
    SeasonATHScore: IDL.Null,
    SeasonLeaderboard: IDL.Null,
    WeeklyLeaderboard: IDL.Null,
    HighestScoringPlayer: IDL.Null,
  });
  const RewardEntry = IDL.Record({
    rewardType: RewardType,
    position: IDL.Nat,
    amount: IDL.Nat64,
    principalId: IDL.Text,
  });
  const WeeklyRewardsDTO = IDL.Record({
    seasonId: SeasonId,
    rewards: IDL.Vec(RewardEntry),
    gameweek: GameweekNumber,
  });
  const Result_2 = IDL.Variant({ ok: WeeklyRewardsDTO, err: Error });
  const IsUsernameValid = IDL.Record({ username: IDL.Text });
  const SaveBonusDTO = IDL.Record({
    goalGetterPlayerId: IDL.Opt(ClubId),
    oneNationCountryId: IDL.Opt(CountryId),
    hatTrickHeroGameweek: IDL.Opt(GameweekNumber),
    oneNationGameweek: IDL.Opt(GameweekNumber),
    teamBoostGameweek: IDL.Opt(GameweekNumber),
    captainFantasticGameweek: IDL.Opt(GameweekNumber),
    noEntryPlayerId: IDL.Opt(ClubId),
    safeHandsPlayerId: IDL.Opt(ClubId),
    braceBonusGameweek: IDL.Opt(GameweekNumber),
    passMasterGameweek: IDL.Opt(GameweekNumber),
    teamBoostClubId: IDL.Opt(ClubId),
    goalGetterGameweek: IDL.Opt(GameweekNumber),
    captainFantasticPlayerId: IDL.Opt(ClubId),
    noEntryGameweek: IDL.Opt(GameweekNumber),
    prospectsGameweek: IDL.Opt(GameweekNumber),
    safeHandsGameweek: IDL.Opt(GameweekNumber),
    passMasterPlayerId: IDL.Opt(ClubId),
  });
  const SaveTeamDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    teamName: IDL.Opt(IDL.Text),
    transferWindowGameweek: IDL.Opt(GameweekNumber),
    captainId: ClubId,
  });
  const GetManagerByUsername = IDL.Record({ username: IDL.Text });
  const UpdateFavouriteClubDTO = IDL.Record({ favouriteClubId: ClubId });
  const UpdateProfilePictureDTO = IDL.Record({
    profilePicture: IDL.Vec(IDL.Nat8),
    extension: IDL.Text,
  });
  const UpdateAppStatusDTO = IDL.Record({
    version: IDL.Text,
    onHold: IDL.Bool,
  });
  const UpdateUsernameDTO = IDL.Record({ username: IDL.Text });
  return IDL.Service({
    calculateWeeklyRewards: IDL.Func([GameweekNumber], [Result], []),
    createManager: IDL.Func([CreateManagerDTO], [Result], []),
    getActiveLeaderboardCanisterId: IDL.Func([], [Result_15], []),
    getActiveRewardRates: IDL.Func([], [Result_14], []),
    getAppStatus: IDL.Func([], [Result_7], ["query"]),
    getCanisters: IDL.Func([GetCanistersDTO], [Result_13], []),
    getCurrentTeam: IDL.Func([], [Result_12], []),
    getDataHashes: IDL.Func([], [Result_11], ["composite_query"]),
    getFantasyTeamSnapshot: IDL.Func([GetManagerGameweekDTO], [Result_10], []),
    getLeaderboardCanisterIds: IDL.Func([], [Result_9], []),
    getManager: IDL.Func([GetManagerDTO], [Result_1], []),
    getManagerCanisterIds: IDL.Func([], [Result_9], []),
    getPlayersSnapshot: IDL.Func(
      [GetSnapshotPlayersDTO],
      [IDL.Vec(PlayerDTO)],
      ["query"],
    ),
    getProfile: IDL.Func([], [Result_8], []),
    getSystemState: IDL.Func([], [Result_7], ["query"]),
    getTopups: IDL.Func([], [IDL.Vec(CanisterTopup)], ["query"]),
    getTotalManagers: IDL.Func([], [Result_6], ["query"]),
    getVerifiedPlayers: IDL.Func([], [Result_5], []),
    getWeeklyCanisters: IDL.Func([], [Result_4], ["query"]),
    getWeeklyLeaderboard: IDL.Func([GetWeeklyLeaderboardDTO], [Result_3], []),
    getWeeklyRewards: IDL.Func([GetWeeklyRewardsDTO], [Result_2], ["query"]),
    isUsernameValid: IDL.Func([IsUsernameValid], [IDL.Bool], ["query"]),
    notifyAppsOfFixtureFinalised: IDL.Func(
      [SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfGameweekStarting: IDL.Func(
      [SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfLoan: IDL.Func([PlayerId], [Result], []),
    notifyAppsOfPositionChange: IDL.Func([PlayerId], [Result], []),
    notifyAppsOfTransfer: IDL.Func([PlayerId], [Result], []),
    payWeeklyRewards: IDL.Func([GameweekNumber], [Result], []),
    saveBonusSelection: IDL.Func([SaveBonusDTO], [Result], []),
    saveTeamSelection: IDL.Func([SaveTeamDTO], [Result], []),
    searchUsername: IDL.Func([GetManagerByUsername], [Result_1], []),
    updateDataHashes: IDL.Func([IDL.Text], [Result], []),
    updateFavouriteClub: IDL.Func([UpdateFavouriteClubDTO], [Result], []),
    updateProfilePicture: IDL.Func([UpdateProfilePictureDTO], [Result], []),
    updateSystemState: IDL.Func([UpdateAppStatusDTO], [Result], []),
    updateUsername: IDL.Func([UpdateUsernameDTO], [Result], []),
  });
};
export const init = ({ IDL }) => {
  return [];
};
