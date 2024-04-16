export const idlFactory = ({ IDL }) => {
  const CreatePrivateLeagueDTO = IDL.Record({ termsAgreed: IDL.Bool });
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotFound: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    CanisterCreateError: IDL.Null,
    InvalidTeamError: IDL.Null,
  });
  const Result_1 = IDL.Variant({ ok: IDL.Null, err: Error });
  const SeasonId = IDL.Nat16;
  const FixtureStatusType = IDL.Variant({
    Unplayed: IDL.Null,
    Finalised: IDL.Null,
    Active: IDL.Null,
    Complete: IDL.Null,
  });
  const ClubId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const PlayerEventType = IDL.Variant({
    PenaltyMissed: IDL.Null,
    Goal: IDL.Null,
    GoalConceded: IDL.Null,
    Appearance: IDL.Null,
    PenaltySaved: IDL.Null,
    RedCard: IDL.Null,
    KeeperSave: IDL.Null,
    CleanSheet: IDL.Null,
    YellowCard: IDL.Null,
    GoalAssisted: IDL.Null,
    OwnGoal: IDL.Null,
    HighestScoringPlayer: IDL.Null,
  });
  const PlayerEventData = IDL.Record({
    fixtureId: FixtureId,
    clubId: ClubId,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType,
  });
  const GameweekNumber = IDL.Nat8;
  const FixtureDTO = IDL.Record({
    id: IDL.Nat32,
    status: FixtureStatusType,
    highestScoringPlayerId: IDL.Nat16,
    seasonId: SeasonId,
    awayClubId: ClubId,
    events: IDL.Vec(PlayerEventData),
    homeClubId: ClubId,
    kickOff: IDL.Int,
    homeGoals: IDL.Nat8,
    gameweek: GameweekNumber,
    awayGoals: IDL.Nat8,
  });
  const AddInitialFixturesDTO = IDL.Record({
    seasonId: SeasonId,
    seasonFixtures: IDL.Vec(FixtureDTO),
  });
  const CountryId = IDL.Nat16;
  const PlayerPosition = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null,
  });
  const CreatePlayerDTO = IDL.Record({
    clubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text,
  });
  const PlayerId = IDL.Nat16;
  const LoanPlayerDTO = IDL.Record({
    loanEndDate: IDL.Int,
    playerId: PlayerId,
    loanClubId: ClubId,
  });
  const Spawn = IDL.Record({
    percentage_to_spawn: IDL.Opt(IDL.Nat32),
    new_controller: IDL.Opt(IDL.Principal),
    nonce: IDL.Opt(IDL.Nat64),
  });
  const NeuronId = IDL.Record({ id: IDL.Nat64 });
  const Follow = IDL.Record({
    topic: IDL.Int32,
    followees: IDL.Vec(NeuronId),
  });
  const ClaimOrRefreshNeuronFromAccount = IDL.Record({
    controller: IDL.Opt(IDL.Principal),
    memo: IDL.Nat64,
  });
  const By = IDL.Variant({
    NeuronIdOrSubaccount: IDL.Null,
    MemoAndController: ClaimOrRefreshNeuronFromAccount,
    Memo: IDL.Nat64,
  });
  const ClaimOrRefresh = IDL.Record({ by: IDL.Opt(By) });
  const ChangeAutoStakeMaturity = IDL.Record({
    requested_setting_for_auto_stake_maturity: IDL.Bool,
  });
  const IncreaseDissolveDelay = IDL.Record({
    additional_dissolve_delay_seconds: IDL.Nat32,
  });
  const SetDissolveTimestamp = IDL.Record({
    dissolve_timestamp_seconds: IDL.Nat64,
  });
  const Operation = IDL.Variant({
    ChangeAutoStakeMaturity: ChangeAutoStakeMaturity,
    StopDissolving: IDL.Null,
    StartDissolving: IDL.Null,
    IncreaseDissolveDelay: IncreaseDissolveDelay,
    SetDissolveTimestamp: SetDissolveTimestamp,
  });
  const Configure = IDL.Record({ operation: IDL.Opt(Operation) });
  const StakeMaturityResponse = IDL.Record({
    maturity_e8s: IDL.Nat64,
    stake_maturity_e8s: IDL.Nat64,
  });
  const AccountIdentifier = IDL.Record({ hash: IDL.Vec(IDL.Nat8) });
  const Amount = IDL.Record({ e8s: IDL.Nat64 });
  const Disburse = IDL.Record({
    to_account: IDL.Opt(AccountIdentifier),
    amount: IDL.Opt(Amount),
  });
  const Command = IDL.Variant({
    Spawn: Spawn,
    Follow: Follow,
    ClaimOrRefresh: ClaimOrRefresh,
    Configure: Configure,
    StakeMaturity: StakeMaturityResponse,
    Disburse: Disburse,
  });
  const MoveFixtureDTO = IDL.Record({
    fixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
  });
  const PostponeFixtureDTO = IDL.Record({ fixtureId: FixtureId });
  const PromoteFormerClubDTO = IDL.Record({ clubId: ClubId });
  const ShirtType = IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null });
  const PromoteNewClubDTO = IDL.Record({
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
  });
  const RecallPlayerDTO = IDL.Record({ playerId: PlayerId });
  const RescheduleFixtureDTO = IDL.Record({
    postponedFixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
  });
  const RetirePlayerDTO = IDL.Record({
    playerId: PlayerId,
    retirementDate: IDL.Int,
  });
  const RevaluePlayerDownDTO = IDL.Record({ playerId: PlayerId });
  const RevaluePlayerUpDTO = IDL.Record({ playerId: PlayerId });
  const SetPlayerInjuryDTO = IDL.Record({
    playerId: PlayerId,
    description: IDL.Text,
    expectedEndDate: IDL.Int,
  });
  const SubmitFixtureDataDTO = IDL.Record({
    fixtureId: FixtureId,
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    playerEventData: IDL.Vec(PlayerEventData),
  });
  const TransferPlayerDTO = IDL.Record({
    playerId: PlayerId,
    newClubId: ClubId,
  });
  const UnretirePlayerDTO = IDL.Record({ playerId: PlayerId });
  const UpdateClubDTO = IDL.Record({
    clubId: ClubId,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
  });
  const UpdatePlayerDTO = IDL.Record({
    dateOfBirth: IDL.Int,
    playerId: PlayerId,
    nationality: CountryId,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text,
  });
  const Result_22 = IDL.Variant({ ok: IDL.Text, err: Error });
  const ClubDTO = IDL.Record({
    id: ClubId,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
  });
  const Result_18 = IDL.Variant({ ok: IDL.Vec(ClubDTO), err: Error });
  const CountryDTO = IDL.Record({
    id: CountryId,
    code: IDL.Text,
    name: IDL.Text,
  });
  const Result_21 = IDL.Variant({ ok: IDL.Vec(CountryDTO), err: Error });
  const PickTeamDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    countrymenCountryId: CountryId,
    username: IDL.Text,
    goalGetterPlayerId: PlayerId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    countrymenGameweek: GameweekNumber,
    bankQuarterMillions: IDL.Nat16,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
    monthlyBonusesAvailable: IDL.Nat8,
  });
  const Result_20 = IDL.Variant({ ok: PickTeamDTO, err: Error });
  const DataCacheDTO = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_19 = IDL.Variant({
    ok: IDL.Vec(DataCacheDTO),
    err: Error,
  });
  const Result_12 = IDL.Variant({ ok: IDL.Vec(FixtureDTO), err: Error });
  const PlayerStatus = IDL.Variant({
    OnLoan: IDL.Null,
    Former: IDL.Null,
    Active: IDL.Null,
    Retired: IDL.Null,
  });
  const PlayerDTO = IDL.Record({
    id: IDL.Nat16,
    status: PlayerStatus,
    clubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    shirtNumber: IDL.Nat8,
    totalPoints: IDL.Int16,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text,
  });
  const Result_7 = IDL.Variant({ ok: IDL.Vec(PlayerDTO), err: Error });
  const CalendarMonth = IDL.Nat8;
  const FantasyTeamSnapshot = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    month: CalendarMonth,
    teamValueQuarterMillions: IDL.Nat16,
    countrymenCountryId: CountryId,
    username: IDL.Text,
    goalGetterPlayerId: PlayerId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    countrymenGameweek: GameweekNumber,
    bankQuarterMillions: IDL.Nat16,
    noEntryPlayerId: PlayerId,
    monthlyPoints: IDL.Int16,
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    favouriteClubId: ClubId,
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
  const ManagerDTO = IDL.Record({
    username: IDL.Text,
    weeklyPosition: IDL.Int,
    createDate: IDL.Int,
    monthlyPoints: IDL.Int16,
    weeklyPoints: IDL.Int16,
    weeklyPositionText: IDL.Text,
    gameweeks: IDL.Vec(FantasyTeamSnapshot),
    favouriteClubId: ClubId,
    monthlyPosition: IDL.Int,
    seasonPosition: IDL.Int,
    monthlyPositionText: IDL.Text,
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    seasonPoints: IDL.Int16,
    principalId: IDL.Text,
    seasonPositionText: IDL.Text,
  });
  const Result_17 = IDL.Variant({ ok: ManagerDTO, err: Error });
  const LeaderboardEntry = IDL.Record({
    username: IDL.Text,
    positionText: IDL.Text,
    position: IDL.Nat,
    principalId: IDL.Text,
    points: IDL.Int16,
  });
  const MonthlyLeaderboardDTO = IDL.Record({
    month: IDL.Nat8,
    clubId: ClubId,
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry),
  });
  const Result_10 = IDL.Variant({
    ok: MonthlyLeaderboardDTO,
    err: Error,
  });
  const Result_16 = IDL.Variant({
    ok: IDL.Vec(MonthlyLeaderboardDTO),
    err: Error,
  });
  const InjuryHistory = IDL.Record({
    description: IDL.Text,
    injuryStartDate: IDL.Int,
    expectedEndDate: IDL.Int,
  });
  const PlayerGameweekDTO = IDL.Record({
    fixtureId: FixtureId,
    events: IDL.Vec(PlayerEventData),
    number: IDL.Nat8,
    points: IDL.Int16,
  });
  const ValueHistory = IDL.Record({
    oldValue: IDL.Nat16,
    newValue: IDL.Nat16,
    seasonId: IDL.Nat16,
    gameweek: IDL.Nat8,
  });
  const PlayerDetailDTO = IDL.Record({
    id: PlayerId,
    status: PlayerStatus,
    clubId: ClubId,
    parentClubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    injuryHistory: IDL.Vec(InjuryHistory),
    seasonId: SeasonId,
    gameweeks: IDL.Vec(PlayerGameweekDTO),
    nationality: CountryId,
    retirementDate: IDL.Int,
    valueHistory: IDL.Vec(ValueHistory),
    latestInjuryEndDate: IDL.Int,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text,
  });
  const Result_15 = IDL.Variant({ ok: PlayerDetailDTO, err: Error });
  const PlayerPointsDTO = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    events: IDL.Vec(PlayerEventData),
    position: PlayerPosition,
    gameweek: GameweekNumber,
    points: IDL.Int16,
  });
  const Result_14 = IDL.Variant({
    ok: IDL.Vec(PlayerPointsDTO),
    err: Error,
  });
  const PlayerScoreDTO = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    assists: IDL.Int16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    goalsScored: IDL.Int16,
    saves: IDL.Int16,
    goalsConceded: IDL.Int16,
    events: IDL.Vec(PlayerEventData),
    position: PlayerPosition,
    points: IDL.Int16,
  });
  const Result_13 = IDL.Variant({
    ok: IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO)),
    err: Error,
  });
  const CanisterId = IDL.Text;
  const PrincipalId = IDL.Text;
  const LeagueMemberDTO = IDL.Record({
    added: IDL.Int,
    username: IDL.Text,
    principalId: PrincipalId,
  });
  const Result_11 = IDL.Variant({
    ok: IDL.Vec(LeagueMemberDTO),
    err: Error,
  });
  const SeasonLeaderboardDTO = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry),
  });
  const Result_6 = IDL.Variant({ ok: SeasonLeaderboardDTO, err: Error });
  const WeeklyLeaderboardDTO = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry),
    gameweek: GameweekNumber,
  });
  const Result_2 = IDL.Variant({ ok: WeeklyLeaderboardDTO, err: Error });
  const PrivateLeagueDTO = IDL.Record({
    created: IDL.Int,
    name: IDL.Text,
    memberCount: IDL.Int,
    seasonPosition: IDL.Nat,
    canisterId: CanisterId,
  });
  const PrivateLeaguesDTO = IDL.Record({
    totalEntries: IDL.Nat,
    entries: IDL.Vec(PrivateLeagueDTO),
  });
  const Result_9 = IDL.Variant({ ok: PrivateLeaguesDTO, err: Error });
  const ProfileDTO = IDL.Record({
    username: IDL.Text,
    termsAccepted: IDL.Bool,
    createDate: IDL.Int,
    favouriteClubId: ClubId,
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    profilePictureType: IDL.Text,
    principalId: IDL.Text,
  });
  const Result_8 = IDL.Variant({ ok: ProfileDTO, err: Error });
  const SeasonDTO = IDL.Record({
    id: SeasonId,
    name: IDL.Text,
    year: IDL.Nat16,
  });
  const Result_5 = IDL.Variant({ ok: IDL.Vec(SeasonDTO), err: Error });
  const SystemStateDTO = IDL.Record({
    pickTeamSeasonId: SeasonId,
    pickTeamSeasonName: IDL.Text,
    calculationSeasonName: IDL.Text,
    calculationGameweek: GameweekNumber,
    transferWindowActive: IDL.Bool,
    pickTeamGameweek: GameweekNumber,
    calculationMonth: CalendarMonth,
    calculationSeasonId: SeasonId,
    onHold: IDL.Bool,
  });
  const Result_4 = IDL.Variant({ ok: SystemStateDTO, err: Error });
  const Result_3 = IDL.Variant({ ok: IDL.Nat, err: Error });
  const UpdateTeamSelectionDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    countrymenCountryId: CountryId,
    goalGetterPlayerId: PlayerId,
    hatTrickHeroGameweek: GameweekNumber,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    countrymenGameweek: GameweekNumber,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
  });
  const Result = IDL.Variant({ ok: IDL.Text, err: IDL.Text });
  const RustResult = IDL.Variant({ Ok: IDL.Null, Err: IDL.Text });
  return IDL.Service({
    burnICPToCycles: IDL.Func([IDL.Nat64], [], []),
    createPrivateLeague: IDL.Func([CreatePrivateLeagueDTO], [Result_1], []),
    executeAddInitialFixtures: IDL.Func([AddInitialFixturesDTO], [], []),
    executeCreateDAONeuron: IDL.Func([], [], []),
    executeCreatePlayer: IDL.Func([CreatePlayerDTO], [], []),
    executeLoanPlayer: IDL.Func([LoanPlayerDTO], [], []),
    executeManageDAONeuron: IDL.Func([Command], [], []),
    executeMoveFixture: IDL.Func([MoveFixtureDTO], [], []),
    executePostponeFixture: IDL.Func([PostponeFixtureDTO], [], []),
    executePromoteFormerClub: IDL.Func([PromoteFormerClubDTO], [], []),
    executePromoteNewClub: IDL.Func([PromoteNewClubDTO], [], []),
    executeRecallPlayer: IDL.Func([RecallPlayerDTO], [], []),
    executeRescheduleFixture: IDL.Func([RescheduleFixtureDTO], [], []),
    executeRetirePlayer: IDL.Func([RetirePlayerDTO], [], []),
    executeRevaluePlayerDown: IDL.Func([RevaluePlayerDownDTO], [], []),
    executeRevaluePlayerUp: IDL.Func([RevaluePlayerUpDTO], [], []),
    executeSetPlayerInjury: IDL.Func([SetPlayerInjuryDTO], [], []),
    executeSubmitFixtureData: IDL.Func([SubmitFixtureDataDTO], [], []),
    executeTransferPlayer: IDL.Func([TransferPlayerDTO], [], []),
    executeUnretirePlayer: IDL.Func([UnretirePlayerDTO], [], []),
    executeUpdateClub: IDL.Func([UpdateClubDTO], [], []),
    executeUpdatePlayer: IDL.Func([UpdatePlayerDTO], [], []),
    getBackendCanisterId: IDL.Func([], [Result_22], ["query"]),
    getClubs: IDL.Func([], [Result_18], ["query"]),
    getCountries: IDL.Func([], [Result_21], ["query"]),
    getCurrentTeam: IDL.Func([], [Result_20], []),
    getDataHashes: IDL.Func([], [Result_19], ["query"]),
    getFixtures: IDL.Func([SeasonId], [Result_12], ["query"]),
    getFormerClubs: IDL.Func([], [Result_18], ["query"]),
    getLoanedPlayers: IDL.Func([ClubId], [Result_7], ["query"]),
    getManager: IDL.Func([IDL.Text], [Result_17], []),
    getMonthlyLeaderboard: IDL.Func(
      [SeasonId, ClubId, CalendarMonth, IDL.Nat, IDL.Nat, IDL.Text],
      [Result_10],
      []
    ),
    getMonthlyLeaderboards: IDL.Func(
      [SeasonId, CalendarMonth],
      [Result_16],
      []
    ),
    getNeuronId: IDL.Func([], [IDL.Nat64], []),
    getPlayerDetails: IDL.Func([PlayerId, SeasonId], [Result_15], ["query"]),
    getPlayerDetailsForGameweek: IDL.Func(
      [SeasonId, GameweekNumber],
      [Result_14],
      ["query"]
    ),
    getPlayers: IDL.Func([], [Result_7], ["query"]),
    getPlayersMap: IDL.Func([SeasonId, GameweekNumber], [Result_13], ["query"]),
    getPostponedFixtures: IDL.Func([], [Result_12], ["query"]),
    getPrivateLeagueMembers: IDL.Func(
      [CanisterId, IDL.Nat, IDL.Nat],
      [Result_11],
      []
    ),
    getPrivateLeagueMonthlyLeaderboard: IDL.Func(
      [CanisterId, SeasonId, CalendarMonth, IDL.Nat, IDL.Nat],
      [Result_10],
      []
    ),
    getPrivateLeagueSeasonLeaderboard: IDL.Func(
      [CanisterId, SeasonId, IDL.Nat, IDL.Nat],
      [Result_6],
      []
    ),
    getPrivateLeagueWeeklyLeaderboard: IDL.Func(
      [CanisterId, SeasonId, GameweekNumber, IDL.Nat, IDL.Nat],
      [Result_2],
      []
    ),
    getPrivateLeagues: IDL.Func([], [Result_9], []),
    getProfile: IDL.Func([], [Result_8], []),
    getRetiredPlayers: IDL.Func([ClubId], [Result_7], ["query"]),
    getSeasonLeaderboard: IDL.Func(
      [SeasonId, IDL.Nat, IDL.Nat, IDL.Text],
      [Result_6],
      []
    ),
    getSeasons: IDL.Func([], [Result_5], ["query"]),
    getSystemState: IDL.Func([], [Result_4], ["query"]),
    getTotalManagers: IDL.Func([], [Result_3], ["query"]),
    getWeeklyLeaderboard: IDL.Func(
      [SeasonId, GameweekNumber, IDL.Nat, IDL.Nat, IDL.Text],
      [Result_2],
      []
    ),
    isUsernameValid: IDL.Func([IDL.Text], [IDL.Bool], ["query"]),
    requestCanisterTopup: IDL.Func([], [], []),
    saveFantasyTeam: IDL.Func([UpdateTeamSelectionDTO], [Result_1], []),
    setTimer: IDL.Func([IDL.Int, IDL.Text], [], []),
    updateFavouriteClub: IDL.Func([ClubId], [Result_1], []),
    updateProfilePicture: IDL.Func(
      [IDL.Vec(IDL.Nat8), IDL.Text],
      [Result_1],
      []
    ),
    updateUsername: IDL.Func([IDL.Text], [Result_1], []),
    validateAddInitialFixtures: IDL.Func(
      [AddInitialFixturesDTO],
      [Result],
      ["query"]
    ),
    validateCreateDAONeuron: IDL.Func([], [RustResult], ["query"]),
    validateCreatePlayer: IDL.Func([CreatePlayerDTO], [Result], ["query"]),
    validateLoanPlayer: IDL.Func([LoanPlayerDTO], [Result], ["query"]),
    validateManageDAONeuron: IDL.Func([], [Result], []),
    validateMoveFixture: IDL.Func([MoveFixtureDTO], [Result], ["query"]),
    validatePostponeFixture: IDL.Func(
      [PostponeFixtureDTO],
      [Result],
      ["query"]
    ),
    validatePromoteFormerClub: IDL.Func(
      [PromoteFormerClubDTO],
      [Result],
      ["query"]
    ),
    validatePromoteNewClub: IDL.Func([PromoteNewClubDTO], [Result], ["query"]),
    validateRecallPlayer: IDL.Func([RecallPlayerDTO], [Result], ["query"]),
    validateRescheduleFixture: IDL.Func(
      [RescheduleFixtureDTO],
      [Result],
      ["query"]
    ),
    validateRetirePlayer: IDL.Func([RetirePlayerDTO], [Result], ["query"]),
    validateRevaluePlayerDown: IDL.Func(
      [RevaluePlayerDownDTO],
      [Result],
      ["query"]
    ),
    validateRevaluePlayerUp: IDL.Func(
      [RevaluePlayerUpDTO],
      [Result],
      ["query"]
    ),
    validateSetPlayerInjury: IDL.Func(
      [SetPlayerInjuryDTO],
      [Result],
      ["query"]
    ),
    validateSubmitFixtureData: IDL.Func(
      [SubmitFixtureDataDTO],
      [Result],
      ["query"]
    ),
    validateTransferPlayer: IDL.Func([TransferPlayerDTO], [Result], ["query"]),
    validateUnretirePlayer: IDL.Func([UnretirePlayerDTO], [Result], ["query"]),
    validateUpdateClub: IDL.Func([UpdateClubDTO], [Result], ["query"]),
    validateUpdatePlayer: IDL.Func([UpdatePlayerDTO], [Result], ["query"]),
  });
};
export const init = ({ IDL }) => {
  return [];
};
