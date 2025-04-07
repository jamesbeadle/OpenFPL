export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    DuplicateData: IDL.Null,
    InvalidProperty: IDL.Null,
    NotFound: IDL.Null,
    IncorrectSetup: IDL.Null,
    NotAuthorized: IDL.Null,
    MaxDataExceeded: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    CanisterCreateError: IDL.Null,
    FailedInterCanisterCall: IDL.Null,
    InsufficientFunds: IDL.Null,
  });
  const Result_17 = IDL.Variant({ ok: IDL.Text, err: Error });
  const RewardRates = IDL.Record({
    monthlyLeaderboardRewardRate: IDL.Nat64,
    allTimeSeasonHighScoreRewardRate: IDL.Nat64,
    highestScoringMatchRewardRate: IDL.Nat64,
    seasonLeaderboardRewardRate: IDL.Nat64,
    mostValuableTeamRewardRate: IDL.Nat64,
    allTimeMonthlyHighScoreRewardRate: IDL.Nat64,
    weeklyLeaderboardRewardRate: IDL.Nat64,
    allTimeWeeklyHighScoreRewardRate: IDL.Nat64,
  });
  const Result_24 = IDL.Variant({ ok: RewardRates, err: Error });
  const PrincipalId = IDL.Text;
  const MembershipType__1 = IDL.Variant({
    Founding: IDL.Null,
    NotClaimed: IDL.Null,
    Seasonal: IDL.Null,
    Lifetime: IDL.Null,
    Monthly: IDL.Null,
    NotEligible: IDL.Null,
    Expired: IDL.Null,
  });
  const ICFCLinkStatus = IDL.Variant({
    PendingVerification: IDL.Null,
    Verified: IDL.Null,
  });
  const ICFCLink = IDL.Record({
    dataHash: IDL.Text,
    membershipType: MembershipType__1,
    linkStatus: ICFCLinkStatus,
    principalId: PrincipalId,
  });
  const AppStatus = IDL.Record({ version: IDL.Text, onHold: IDL.Bool });
  const Result_23 = IDL.Variant({ ok: AppStatus, err: Error });
  const GetClubs = IDL.Record({ leagueId: IDL.Nat16 });
  const ShirtType = IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null });
  const Club = IDL.Record({
    id: IDL.Nat16,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
  });
  const Clubs = IDL.Record({ clubs: IDL.Vec(Club), leagueId: IDL.Nat16 });
  const Result_22 = IDL.Variant({ ok: Clubs, err: Error });
  const Country = IDL.Record({
    id: IDL.Nat16,
    code: IDL.Text,
    name: IDL.Text,
  });
  const Countries = IDL.Record({ countries: IDL.Vec(Country) });
  const Result_21 = IDL.Variant({ ok: Countries, err: Error });
  const DataHash = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_20 = IDL.Variant({ ok: IDL.Vec(DataHash), err: Error });
  const SeasonId = IDL.Nat16;
  const GameweekNumber = IDL.Nat8;
  const GetFantasyTeamSnapshot = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    principalId: PrincipalId,
  });
  const PlayerId = IDL.Nat16;
  const CalendarMonth = IDL.Nat8;
  const CountryId = IDL.Nat16;
  const ClubId = IDL.Nat16;
  const FantasyTeamSnapshot = IDL.Record({
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
    principalId: PrincipalId,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId,
    points: IDL.Int16,
    monthlyBonusesAvailable: IDL.Nat8,
  });
  const Result_19 = IDL.Variant({ ok: FantasyTeamSnapshot, err: Error });
  const GetFixtures = IDL.Record({
    seasonId: IDL.Nat16,
    leagueId: IDL.Nat16,
  });
  const FixtureStatusType = IDL.Variant({
    Unplayed: IDL.Null,
    Finalised: IDL.Null,
    Active: IDL.Null,
    Complete: IDL.Null,
  });
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
  const PlayerEventData__1 = IDL.Record({
    fixtureId: IDL.Nat32,
    clubId: IDL.Nat16,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType,
  });
  const Fixture = IDL.Record({
    id: IDL.Nat32,
    status: FixtureStatusType,
    highestScoringPlayerId: IDL.Nat16,
    seasonId: IDL.Nat16,
    awayClubId: IDL.Nat16,
    events: IDL.Vec(PlayerEventData__1),
    homeClubId: IDL.Nat16,
    kickOff: IDL.Int,
    homeGoals: IDL.Nat8,
    gameweek: IDL.Nat8,
    awayGoals: IDL.Nat8,
  });
  const Fixtures = IDL.Record({
    seasonId: IDL.Nat16,
    fixtures: IDL.Vec(Fixture),
    leagueId: IDL.Nat16,
  });
  const Result_18 = IDL.Variant({ ok: Fixtures, err: Error });
  const Result_16 = IDL.Variant({ ok: ICFCLinkStatus, err: Error });
  const CanisterId = IDL.Text;
  const Result_13 = IDL.Variant({ ok: IDL.Vec(CanisterId), err: Error });
  const LeagueStatus = IDL.Record({
    transferWindowEndMonth: IDL.Nat8,
    transferWindowEndDay: IDL.Nat8,
    transferWindowStartMonth: IDL.Nat8,
    transferWindowActive: IDL.Bool,
    totalGameweeks: IDL.Nat8,
    completedGameweek: IDL.Nat8,
    transferWindowStartDay: IDL.Nat8,
    unplayedGameweek: IDL.Nat8,
    activeMonth: IDL.Nat8,
    activeSeasonId: IDL.Nat16,
    activeGameweek: IDL.Nat8,
    leagueId: IDL.Nat16,
    seasonActive: IDL.Bool,
  });
  const Result_15 = IDL.Variant({ ok: LeagueStatus, err: Error });
  const GetManager = IDL.Record({ principalId: IDL.Text });
  const Manager = IDL.Record({
    username: IDL.Text,
    weeklyPosition: IDL.Int,
    createDate: IDL.Int,
    monthlyPoints: IDL.Int16,
    weeklyPoints: IDL.Int16,
    weeklyPositionText: IDL.Text,
    gameweeks: IDL.Vec(FantasyTeamSnapshot),
    favouriteClubId: IDL.Opt(ClubId),
    monthlyPosition: IDL.Int,
    seasonPosition: IDL.Int,
    monthlyPositionText: IDL.Text,
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    seasonPoints: IDL.Int16,
    profilePictureType: IDL.Text,
    principalId: PrincipalId,
    seasonPositionText: IDL.Text,
  });
  const Result_14 = IDL.Variant({ ok: Manager, err: Error });
  const GetManagerByUsername = IDL.Record({ username: IDL.Text });
  const GetPlayerDetails = IDL.Record({
    playerId: IDL.Nat16,
    seasonId: IDL.Nat16,
    leagueId: IDL.Nat16,
  });
  const PlayerStatus__2 = IDL.Variant({
    OnLoan: IDL.Null,
    Active: IDL.Null,
    FreeAgent: IDL.Null,
    Retired: IDL.Null,
  });
  const InjuryHistory = IDL.Record({
    description: IDL.Text,
    injuryStartDate: IDL.Int,
    expectedEndDate: IDL.Int,
  });
  const FixtureId = IDL.Nat32;
  const PlayerEventType__1 = IDL.Variant({
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
    eventType: PlayerEventType__1,
  });
  const PlayerGameweek = IDL.Record({
    fixtureId: FixtureId,
    events: IDL.Vec(PlayerEventData),
    number: IDL.Nat8,
    points: IDL.Int16,
  });
  const ValueHistory = IDL.Record({
    oldValue: IDL.Nat16,
    changedOn: IDL.Int,
    newValue: IDL.Nat16,
  });
  const PlayerPosition__2 = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null,
  });
  const DetailedPlayer = IDL.Record({
    id: PlayerId,
    status: PlayerStatus__2,
    clubId: ClubId,
    parentClubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    injuryHistory: IDL.Vec(InjuryHistory),
    seasonId: SeasonId,
    gameweeks: IDL.Vec(PlayerGameweek),
    nationality: CountryId,
    retirementDate: IDL.Int,
    valueHistory: IDL.Vec(ValueHistory),
    latestInjuryEndDate: IDL.Int,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition__2,
    lastName: IDL.Text,
    firstName: IDL.Text,
  });
  const PlayerDetails = IDL.Record({ player: DetailedPlayer });
  const Result_12 = IDL.Variant({ ok: PlayerDetails, err: Error });
  const GetPlayerDetailsForGameweek = IDL.Record({
    seasonId: IDL.Nat16,
    gameweek: IDL.Nat8,
    leagueId: IDL.Nat16,
  });
  const PlayerEventData__2 = IDL.Record({
    fixtureId: IDL.Nat32,
    clubId: IDL.Nat16,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType,
  });
  const PlayerPosition__1 = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null,
  });
  const PlayerPoints = IDL.Record({
    id: IDL.Nat16,
    clubId: IDL.Nat16,
    events: IDL.Vec(PlayerEventData__2),
    position: PlayerPosition__1,
    gameweek: IDL.Nat8,
    points: IDL.Int16,
  });
  const PlayerDetailsForGameweek = IDL.Record({
    playerPoints: IDL.Vec(PlayerPoints),
  });
  const Result_11 = IDL.Variant({
    ok: PlayerDetailsForGameweek,
    err: Error,
  });
  const GetPlayers = IDL.Record({ leagueId: IDL.Nat16 });
  const PlayerStatus__1 = IDL.Variant({
    OnLoan: IDL.Null,
    Active: IDL.Null,
    FreeAgent: IDL.Null,
    Retired: IDL.Null,
  });
  const Player__1 = IDL.Record({
    id: IDL.Nat16,
    status: PlayerStatus__1,
    clubId: IDL.Nat16,
    parentClubId: IDL.Nat16,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: IDL.Nat16,
    currentLoanEndDate: IDL.Int,
    shirtNumber: IDL.Nat8,
    parentLeagueId: IDL.Nat16,
    position: PlayerPosition__1,
    lastName: IDL.Text,
    leagueId: IDL.Nat16,
    firstName: IDL.Text,
  });
  const Players = IDL.Record({ players: IDL.Vec(Player__1) });
  const Result_10 = IDL.Variant({ ok: Players, err: Error });
  const GetPlayersMap = IDL.Record({
    seasonId: IDL.Nat16,
    gameweek: IDL.Nat8,
    leagueId: IDL.Nat16,
  });
  const PlayerScore = IDL.Record({
    id: IDL.Nat16,
    clubId: IDL.Nat16,
    assists: IDL.Int16,
    dateOfBirth: IDL.Int,
    nationality: IDL.Nat16,
    goalsScored: IDL.Int16,
    saves: IDL.Int16,
    goalsConceded: IDL.Int16,
    events: IDL.Vec(PlayerEventData__2),
    position: PlayerPosition__1,
    points: IDL.Int16,
  });
  const PlayersMap = IDL.Record({
    playersMap: IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScore)),
  });
  const Result_9 = IDL.Variant({ ok: PlayersMap, err: Error });
  const GetPlayersSnapshot = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
  });
  const PlayerStatus = IDL.Variant({
    OnLoan: IDL.Null,
    Active: IDL.Null,
    FreeAgent: IDL.Null,
    Retired: IDL.Null,
  });
  const PlayerPosition = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null,
  });
  const Player = IDL.Record({
    id: IDL.Nat16,
    status: PlayerStatus,
    clubId: IDL.Nat16,
    parentClubId: IDL.Nat16,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: IDL.Nat16,
    currentLoanEndDate: IDL.Int,
    shirtNumber: IDL.Nat8,
    parentLeagueId: IDL.Nat16,
    position: PlayerPosition,
    lastName: IDL.Text,
    leagueId: IDL.Nat16,
    firstName: IDL.Text,
  });
  const PlayersSnapshot = IDL.Record({ players: IDL.Vec(Player) });
  const Result_8 = IDL.Variant({ ok: PlayersSnapshot, err: Error });
  const GetPostponedFixtures = IDL.Record({ leagueId: IDL.Nat16 });
  const PostponedFixtures = IDL.Record({
    seasonId: IDL.Nat16,
    fixtures: IDL.Vec(Fixture),
    leagueId: IDL.Nat16,
  });
  const Result_7 = IDL.Variant({ ok: PostponedFixtures, err: Error });
  const MembershipClaim = IDL.Record({
    expiresOn: IDL.Opt(IDL.Int),
    purchasedOn: IDL.Int,
    membershipType: MembershipType__1,
  });
  const LeagueId = IDL.Nat16;
  const CombinedProfile = IDL.Record({
    username: IDL.Text,
    displayName: IDL.Text,
    termsAccepted: IDL.Bool,
    createdOn: IDL.Int,
    createDate: IDL.Int,
    favouriteClubId: IDL.Opt(ClubId),
    membershipClaims: IDL.Vec(MembershipClaim),
    profilePicture: IDL.Opt(IDL.Vec(IDL.Nat8)),
    membershipType: MembershipType__1,
    termsAgreed: IDL.Bool,
    membershipExpiryTime: IDL.Int,
    favouriteLeagueId: IDL.Opt(LeagueId),
    nationalityId: IDL.Opt(CountryId),
    profilePictureType: IDL.Text,
    principalId: PrincipalId,
  });
  const Result_6 = IDL.Variant({ ok: CombinedProfile, err: Error });
  const GetSeasons = IDL.Record({ leagueId: IDL.Nat16 });
  const Season = IDL.Record({
    id: IDL.Nat16,
    name: IDL.Text,
    year: IDL.Nat16,
  });
  const Seasons = IDL.Record({ seasons: IDL.Vec(Season) });
  const Result_5 = IDL.Variant({ ok: Seasons, err: Error });
  const TeamSetup = IDL.Record({
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
  const Result_4 = IDL.Variant({ ok: TeamSetup, err: Error });
  const Result_3 = IDL.Variant({ ok: IDL.Nat, err: Error });
  const GetWeeklyLeaderboard = IDL.Record({
    offset: IDL.Nat,
    seasonId: SeasonId,
    limit: IDL.Nat,
    searchTerm: IDL.Text,
    gameweek: GameweekNumber,
  });
  const LeaderboardEntry = IDL.Record({
    username: IDL.Text,
    positionText: IDL.Text,
    position: IDL.Nat,
    principalId: IDL.Text,
    points: IDL.Int16,
  });
  const WeeklyLeaderboard = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry),
    gameweek: GameweekNumber,
  });
  const Result_2 = IDL.Variant({ ok: WeeklyLeaderboard, err: Error });
  const GetWeeklyRewardsLeaderboard = IDL.Record({
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
  const WeeklyRewardsLeaderboard = IDL.Record({
    seasonId: SeasonId,
    entries: IDL.Vec(RewardEntry),
    gameweek: GameweekNumber,
  });
  const Result_1 = IDL.Variant({
    ok: WeeklyRewardsLeaderboard,
    err: Error,
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const SubApp = IDL.Variant({
    OpenFPL: IDL.Null,
    OpenWSL: IDL.Null,
    FootballGod: IDL.Null,
    TransferKings: IDL.Null,
    JeffBets: IDL.Null,
  });
  const MembershipType = IDL.Variant({
    Founding: IDL.Null,
    NotClaimed: IDL.Null,
    Seasonal: IDL.Null,
    Lifetime: IDL.Null,
    Monthly: IDL.Null,
    NotEligible: IDL.Null,
    Expired: IDL.Null,
  });
  const UpdateICFCProfile = IDL.Record({
    subApp: SubApp,
    subAppUserPrincipalId: PrincipalId,
    membershipType: MembershipType,
  });
  const NotifyAppofLink = IDL.Record({
    icfcPrincipalId: PrincipalId,
    subApp: SubApp,
    subAppUserPrincipalId: PrincipalId,
    membershipType: MembershipType,
  });
  const NotifyAppofRemoveLink = IDL.Record({
    icfcPrincipalId: PrincipalId,
    subApp: SubApp,
  });
  const BonusType = IDL.Variant({
    NoEntry: IDL.Null,
    Prospects: IDL.Null,
    PassMaster: IDL.Null,
    TeamBoost: IDL.Null,
    OneNation: IDL.Null,
    CaptainFantastic: IDL.Null,
    HatTrickHero: IDL.Null,
    SafeHands: IDL.Null,
    GoalGetter: IDL.Null,
    BraceBonus: IDL.Null,
  });
  const PlayBonus = IDL.Record({
    clubId: ClubId,
    playerId: PlayerId,
    countryId: CountryId,
    bonusType: BonusType,
    principalId: PrincipalId,
  });
  const SaveFantasyTeam = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    playTransferWindowBonus: IDL.Bool,
    principalId: PrincipalId,
    captainId: ClubId,
  });
  const SetFavouriteClub = IDL.Record({
    favouriteClubId: ClubId,
    principalId: PrincipalId,
  });
  return IDL.Service({
    getActiveLeaderboardCanisterId: IDL.Func([], [Result_17], []),
    getActiveRewardRates: IDL.Func([], [Result_24], []),
    getAllUserICFCLinks: IDL.Func(
      [],
      [IDL.Vec(IDL.Tuple(PrincipalId, ICFCLink))],
      [],
    ),
    getAppStatus: IDL.Func([], [Result_23], []),
    getClubs: IDL.Func([GetClubs], [Result_22], []),
    getCountries: IDL.Func([], [Result_21], []),
    getDataHashes: IDL.Func([], [Result_20], []),
    getFantasyTeamSnapshot: IDL.Func([GetFantasyTeamSnapshot], [Result_19], []),
    getFixtures: IDL.Func([GetFixtures], [Result_18], []),
    getICFCDataHash: IDL.Func([], [Result_17], []),
    getICFCLinkStatus: IDL.Func([], [Result_16], []),
    getLeaderboardCanisterIds: IDL.Func([], [Result_13], []),
    getLeagueStatus: IDL.Func([], [Result_15], []),
    getManager: IDL.Func([GetManager], [Result_14], []),
    getManagerByUsername: IDL.Func([GetManagerByUsername], [Result_14], []),
    getManagerCanisterIds: IDL.Func([], [Result_13], []),
    getPlayerDetails: IDL.Func([GetPlayerDetails], [Result_12], []),
    getPlayerEvents: IDL.Func([GetPlayerDetailsForGameweek], [Result_11], []),
    getPlayers: IDL.Func([GetPlayers], [Result_10], []),
    getPlayersMap: IDL.Func([GetPlayersMap], [Result_9], []),
    getPlayersSnapshot: IDL.Func([GetPlayersSnapshot], [Result_8], []),
    getPostponedFixtures: IDL.Func([GetPostponedFixtures], [Result_7], []),
    getProfile: IDL.Func([], [Result_6], []),
    getSeasons: IDL.Func([GetSeasons], [Result_5], []),
    getTeamSelection: IDL.Func([], [Result_4], []),
    getTotalManagers: IDL.Func([], [Result_3], []),
    getWeeklyLeaderboard: IDL.Func([GetWeeklyLeaderboard], [Result_2], []),
    getWeeklyRewards: IDL.Func(
      [GetWeeklyRewardsLeaderboard],
      [Result_1],
      ["query"],
    ),
    linkICFCProfile: IDL.Func([], [Result], []),
    noitifyAppofICFCHashUpdate: IDL.Func([UpdateICFCProfile], [Result], []),
    notifyAppLink: IDL.Func([NotifyAppofLink], [Result], []),
    notifyAppRemoveLink: IDL.Func([NotifyAppofRemoveLink], [Result], []),
    notifyAppsOfFixtureFinalised: IDL.Func(
      [LeagueId, SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfGameweekStarting: IDL.Func(
      [LeagueId, SeasonId, GameweekNumber],
      [Result],
      [],
    ),
    notifyAppsOfLoan: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfLoanExpired: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfPositionChange: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfRetirement: IDL.Func([LeagueId, PlayerId], [Result], []),
    notifyAppsOfSeasonComplete: IDL.Func([LeagueId, SeasonId], [Result], []),
    notifyAppsOfTransfer: IDL.Func([LeagueId, PlayerId], [Result], []),
    saveBonusSelection: IDL.Func([PlayBonus], [Result], []),
    saveTeamSelection: IDL.Func([SaveFantasyTeam], [Result], []),
    updateDataHashes: IDL.Func([IDL.Text], [Result], []),
    updateFavouriteClub: IDL.Func([SetFavouriteClub], [Result], []),
  });
};
export const init = ({ IDL }) => {
  return [];
};
