export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const List_2 = IDL.Rec();
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
  const Result = IDL.Variant({ ok: IDL.Text, err: IDL.Text });
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
  const ShirtType = IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null });
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
  const AdminClubList = IDL.Record({
    totalEntries: IDL.Nat,
    clubs: IDL.Vec(ClubDTO),
    offset: IDL.Nat,
    limit: IDL.Nat,
  });
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotFound: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    InvalidTeamError: IDL.Null,
  });
  const Result_28 = IDL.Variant({ ok: AdminClubList, err: Error });
  const AdminFixtureList = IDL.Record({
    seasonId: SeasonId,
    fixtures: IDL.Vec(FixtureDTO),
  });
  const Result_27 = IDL.Variant({ ok: AdminFixtureList, err: Error });
  const PlayerId = IDL.Nat16;
  const FantasyTeamSnapshot = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
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
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    favouriteClubId: ClubId,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    gameweek: GameweekNumber,
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
  List_1.fill(IDL.Opt(IDL.Tuple(FantasyTeamSnapshot, List_1)));
  const FantasyTeamSeason = IDL.Record({
    seasonId: SeasonId,
    gameweeks: List_1,
    totalPoints: IDL.Int16,
  });
  List.fill(IDL.Opt(IDL.Tuple(FantasyTeamSeason, List)));
  const ProfileDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    countrymenCountryId: CountryId,
    username: IDL.Text,
    goalGetterPlayerId: PlayerId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    termsAccepted: IDL.Bool,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    createDate: IDL.Int,
    countrymenGameweek: GameweekNumber,
    bankQuarterMillions: IDL.Nat16,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    history: List,
    braceBonusGameweek: GameweekNumber,
    favouriteClubId: ClubId,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    profilePicture: IDL.Vec(IDL.Nat8),
    transferWindowGameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    prospectsGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
    monthlyBonusesAvailable: IDL.Nat8,
  });
  const AdminProfileList = IDL.Record({
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    profiles: IDL.Vec(ProfileDTO),
  });
  const Result_26 = IDL.Variant({ ok: AdminProfileList, err: Error });
  const CalendarMonth = IDL.Nat8;
  const MonthlyLeaderboardCanister = IDL.Record({
    month: CalendarMonth,
    clubId: ClubId,
    seasonId: SeasonId,
    canisterId: IDL.Text,
  });
  const MonthlyCanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    canister: MonthlyLeaderboardCanister,
  });
  const AdminMonthlyCanisterList = IDL.Record({
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    canisters: IDL.Vec(MonthlyCanisterDTO),
  });
  const Result_25 = IDL.Variant({
    ok: AdminMonthlyCanisterList,
    err: Error,
  });
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
  const AdminPlayerList = IDL.Record({
    playerStatus: PlayerStatus,
    players: IDL.Vec(PlayerDTO),
  });
  const Result_24 = IDL.Variant({ ok: AdminPlayerList, err: Error });
  const ProfileCanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    canisterId: IDL.Text,
  });
  const AdminProfilePictureCanisterList = IDL.Record({
    totalEntries: IDL.Nat,
    canisters: IDL.Vec(ProfileCanisterDTO),
  });
  const Result_23 = IDL.Variant({
    ok: AdminProfilePictureCanisterList,
    err: Error,
  });
  const SeasonLeaderboardCanister = IDL.Record({
    seasonId: SeasonId,
    canisterId: IDL.Text,
  });
  const SeasonCanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    canister: SeasonLeaderboardCanister,
  });
  const AdminSeasonCanisterList = IDL.Record({
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    canisters: IDL.Vec(SeasonCanisterDTO),
  });
  const Result_22 = IDL.Variant({
    ok: AdminSeasonCanisterList,
    err: Error,
  });
  const TimerDTO = IDL.Record({
    id: IDL.Int,
    callbackName: IDL.Text,
    triggerTime: IDL.Int,
  });
  const AdminTimerList = IDL.Record({
    timers: IDL.Vec(TimerDTO),
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
  });
  const Result_21 = IDL.Variant({ ok: AdminTimerList, err: Error });
  const WeeklyLeaderboardCanister = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    canisterId: IDL.Text,
  });
  const WeeklyCanisterDTO = IDL.Record({
    cycles: IDL.Nat,
    canister: WeeklyLeaderboardCanister,
  });
  const AdminWeeklyCanisterList = IDL.Record({
    totalEntries: IDL.Nat,
    offset: IDL.Nat,
    limit: IDL.Nat,
    canisters: IDL.Vec(WeeklyCanisterDTO),
  });
  const Result_20 = IDL.Variant({
    ok: AdminWeeklyCanisterList,
    err: Error,
  });
  const LoanPlayerDTO = IDL.Record({
    loanEndDate: IDL.Int,
    playerId: PlayerId,
    loanClubId: ClubId,
  });
  const PromoteFormerClubDTO = IDL.Record({ clubId: ClubId });
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
    fixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
    seasonId: SeasonId,
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
  const Result_19 = IDL.Variant({ ok: IDL.Vec(ClubDTO), err: Error });
  const CountryDTO = IDL.Record({
    id: CountryId,
    code: IDL.Text,
    name: IDL.Text,
  });
  const Result_18 = IDL.Variant({ ok: IDL.Vec(CountryDTO), err: Error });
  const DataCacheDTO = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_17 = IDL.Variant({
    ok: IDL.Vec(DataCacheDTO),
    err: Error,
  });
  const Result_16 = IDL.Variant({ ok: IDL.Vec(FixtureDTO), err: Error });
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
    profilePicture: IDL.Vec(IDL.Nat8),
    seasonPoints: IDL.Int16,
    principalId: IDL.Text,
    seasonPositionText: IDL.Text,
  });
  const Result_15 = IDL.Variant({ ok: ManagerDTO, err: Error });
  const ManagerGameweekDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
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
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    favouriteClubId: ClubId,
    passMasterGameweek: GameweekNumber,
    teamBoostClubId: ClubId,
    goalGetterGameweek: GameweekNumber,
    captainFantasticPlayerId: PlayerId,
    gameweek: GameweekNumber,
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
  const Result_14 = IDL.Variant({ ok: ManagerGameweekDTO, err: Error });
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
  const Result_13 = IDL.Variant({
    ok: MonthlyLeaderboardDTO,
    err: Error,
  });
  const Result_12 = IDL.Variant({
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
    isInjured: IDL.Bool,
    gameweeks: IDL.Vec(PlayerGameweekDTO),
    nationality: CountryId,
    retirementDate: IDL.Int,
    valueHistory: IDL.Vec(ValueHistory),
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text,
  });
  const Result_11 = IDL.Variant({ ok: PlayerDetailDTO, err: Error });
  const PlayerPointsDTO = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    events: IDL.Vec(PlayerEventData),
    position: PlayerPosition,
    gameweek: GameweekNumber,
    points: IDL.Int16,
  });
  const Result_10 = IDL.Variant({
    ok: IDL.Vec(PlayerPointsDTO),
    err: Error,
  });
  const Result_9 = IDL.Variant({ ok: IDL.Vec(PlayerDTO), err: Error });
  List_2.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List_2)));
  const PlayerScoreDTO = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    assists: IDL.Int16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    goalsScored: IDL.Int16,
    saves: IDL.Int16,
    goalsConceded: IDL.Int16,
    events: List_2,
    position: PlayerPosition,
    points: IDL.Int16,
  });
  const Result_8 = IDL.Variant({
    ok: IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO)),
    err: Error,
  });
  const Result_7 = IDL.Variant({ ok: ProfileDTO, err: Error });
  const PublicProfileDTO = IDL.Record({
    username: IDL.Text,
    createDate: IDL.Int,
    gameweeks: IDL.Vec(FantasyTeamSnapshot),
    favouriteClubId: IDL.Nat16,
    profilePicture: IDL.Vec(IDL.Nat8),
    principalId: IDL.Text,
  });
  const Result_6 = IDL.Variant({ ok: PublicProfileDTO, err: Error });
  const SeasonLeaderboardDTO = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry),
  });
  const Result_5 = IDL.Variant({ ok: SeasonLeaderboardDTO, err: Error });
  const SystemStateDTO = IDL.Record({
    pickTeamSeasonId: SeasonId,
    pickTeamSeasonName: IDL.Text,
    calculationSeasonName: IDL.Text,
    calculationGameweek: GameweekNumber,
    pickTeamGameweek: GameweekNumber,
    calculationMonth: CalendarMonth,
    calculationSeasonId: SeasonId,
  });
  const Result_4 = IDL.Variant({ ok: SystemStateDTO, err: Error });
  const Result_3 = IDL.Variant({ ok: IDL.Nat, err: Error });
  const WeeklyLeaderboardDTO = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry),
    gameweek: GameweekNumber,
  });
  const Result_2 = IDL.Variant({ ok: WeeklyLeaderboardDTO, err: Error });
  const UpdateFantasyTeamDTO = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    countrymenCountryId: CountryId,
    username: IDL.Text,
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
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
  });
  const Result_1 = IDL.Variant({ ok: IDL.Null, err: Error });
  const UpdateFixtureDTO = IDL.Record({
    status: FixtureStatusType,
    fixtureId: FixtureId,
    seasonId: SeasonId,
    kickOff: IDL.Int,
    gameweek: GameweekNumber,
  });
  const UpdateSystemStateDTO = IDL.Record({
    pickTeamSeasonId: SeasonId,
    calculationGameweek: GameweekNumber,
    transferWindowActive: IDL.Bool,
    pickTeamGameweek: GameweekNumber,
    calculationMonth: CalendarMonth,
    calculationSeasonId: SeasonId,
    onHold: IDL.Bool,
  });
  return IDL.Service({
    adminAddInitialFixtures: IDL.Func([AddInitialFixturesDTO], [Result], []),
    adminCreatePlayer: IDL.Func([CreatePlayerDTO], [Result], []),
    adminGetClubs: IDL.Func([IDL.Nat, IDL.Nat], [Result_28], ["query"]),
    adminGetFixtures: IDL.Func([SeasonId], [Result_27], ["query"]),
    adminGetManagers: IDL.Func([IDL.Nat, IDL.Nat], [Result_26], ["query"]),
    adminGetMonthlyCanisters: IDL.Func([IDL.Nat, IDL.Nat], [Result_25], []),
    adminGetPlayers: IDL.Func([PlayerStatus], [Result_24], ["query"]),
    adminGetProfileCanisters: IDL.Func([IDL.Nat, IDL.Nat], [Result_23], []),
    adminGetSeasonCanisters: IDL.Func([IDL.Nat, IDL.Nat], [Result_22], []),
    adminGetTimers: IDL.Func([IDL.Nat, IDL.Nat], [Result_21], ["query"]),
    adminGetWeeklyCanisters: IDL.Func([IDL.Nat, IDL.Nat], [Result_20], []),
    adminLoanPlayer: IDL.Func([LoanPlayerDTO], [Result], []),
    adminPromoteFormerClub: IDL.Func([PromoteFormerClubDTO], [Result], []),
    adminPromoteNewClub: IDL.Func([PromoteNewClubDTO], [Result], []),
    adminRecallPlayer: IDL.Func([RecallPlayerDTO], [Result], []),
    adminRescheduleFixture: IDL.Func([RescheduleFixtureDTO], [Result], []),
    adminRetirePlayer: IDL.Func([RetirePlayerDTO], [Result], []),
    adminRevaluePlayerDown: IDL.Func([RevaluePlayerDownDTO], [Result], []),
    adminRevaluePlayerUp: IDL.Func([RevaluePlayerUpDTO], [Result], []),
    adminSetPlayerInjury: IDL.Func([SetPlayerInjuryDTO], [Result], []),
    adminSubmitFixtureData: IDL.Func([SubmitFixtureDataDTO], [Result], []),
    adminTransferPlayer: IDL.Func([TransferPlayerDTO], [Result], []),
    adminUnretirePlayer: IDL.Func([UnretirePlayerDTO], [Result], []),
    adminUpdateClub: IDL.Func([UpdateClubDTO], [Result], []),
    adminUpdatePlayer: IDL.Func([UpdatePlayerDTO], [Result], []),
    burnICPToCycles: IDL.Func([IDL.Nat64], [], []),
    executeAddInitialFixtures: IDL.Func([AddInitialFixturesDTO], [], []),
    executeCreatePlayer: IDL.Func([CreatePlayerDTO], [], []),
    executeLoanPlayer: IDL.Func([LoanPlayerDTO], [], []),
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
    getClubs: IDL.Func([], [Result_19], ["query"]),
    getCountries: IDL.Func([], [Result_18], ["query"]),
    getDataHashes: IDL.Func([], [Result_17], ["query"]),
    getFixtures: IDL.Func([SeasonId], [Result_16], ["query"]),
    getManager: IDL.Func([], [Result_15], []),
    getManagerGameweek: IDL.Func(
      [IDL.Text, SeasonId, GameweekNumber],
      [Result_14],
      []
    ),
    getMonthlyLeaderboard: IDL.Func(
      [SeasonId, ClubId, CalendarMonth, IDL.Nat, IDL.Nat],
      [Result_13],
      []
    ),
    getMonthlyLeaderboards: IDL.Func(
      [SeasonId, CalendarMonth],
      [Result_12],
      []
    ),
    getPlayerDetails: IDL.Func([PlayerId, SeasonId], [Result_11], []),
    getPlayerDetailsForGameweek: IDL.Func(
      [SeasonId, GameweekNumber],
      [Result_10],
      ["query"]
    ),
    getPlayers: IDL.Func([], [Result_9], ["query"]),
    getPlayersMap: IDL.Func([SeasonId, GameweekNumber], [Result_8], []),
    getProfile: IDL.Func([], [Result_7], []),
    getPublicProfile: IDL.Func(
      [IDL.Text, SeasonId, GameweekNumber],
      [Result_6],
      []
    ),
    getSeasonLeaderboard: IDL.Func(
      [SeasonId, IDL.Nat, IDL.Nat],
      [Result_5],
      []
    ),
    getSystemState: IDL.Func([], [Result_4], ["query"]),
    getTotalManagers: IDL.Func([], [Result_3], ["query"]),
    getWeeklyLeaderboard: IDL.Func(
      [SeasonId, GameweekNumber, IDL.Nat, IDL.Nat],
      [Result_2],
      []
    ),
    init: IDL.Func([], [], []),
    isUsernameValid: IDL.Func([IDL.Text], [IDL.Bool], ["query"]),
    requestCanisterTopup: IDL.Func([], [], []),
    saveFantasyTeam: IDL.Func([UpdateFantasyTeamDTO], [Result_1], []),
    updateFavouriteClub: IDL.Func([ClubId], [Result_1], []),
    updateFixture: IDL.Func([UpdateFixtureDTO], [Result_1], []),
    updateProfilePicture: IDL.Func([IDL.Vec(IDL.Nat8)], [Result_1], []),
    updateSystemState: IDL.Func([UpdateSystemStateDTO], [Result_1], []),
    updateUsername: IDL.Func([IDL.Text], [Result_1], []),
    validateAddInitialFixtures: IDL.Func([AddInitialFixturesDTO], [Result], []),
    validateCreatePlayer: IDL.Func([CreatePlayerDTO], [Result], []),
    validateLoanPlayer: IDL.Func([LoanPlayerDTO], [Result], []),
    validatePromoteFormerClub: IDL.Func([PromoteFormerClubDTO], [Result], []),
    validatePromoteNewClub: IDL.Func([PromoteNewClubDTO], [Result], []),
    validateRecallPlayer: IDL.Func([RecallPlayerDTO], [Result], []),
    validateRescheduleFixture: IDL.Func([RescheduleFixtureDTO], [Result], []),
    validateRetirePlayer: IDL.Func([RetirePlayerDTO], [Result], []),
    validateRevaluePlayerDown: IDL.Func([RevaluePlayerDownDTO], [Result], []),
    validateRevaluePlayerUp: IDL.Func([RevaluePlayerUpDTO], [Result], []),
    validateSetPlayerInjury: IDL.Func([SetPlayerInjuryDTO], [Result], []),
    validateSubmitFixtureData: IDL.Func([SubmitFixtureDataDTO], [Result], []),
    validateTransferPlayer: IDL.Func([TransferPlayerDTO], [Result], []),
    validateUnretirePlayer: IDL.Func([UnretirePlayerDTO], [Result], []),
    validateUpdateClub: IDL.Func([UpdateClubDTO], [Result], []),
    validateUpdatePlayer: IDL.Func([UpdatePlayerDTO], [Result], []),
  });
};
export const init = ({ IDL }) => {
  return [];
};
