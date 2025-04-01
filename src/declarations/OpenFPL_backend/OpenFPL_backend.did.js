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
  const Result_12 = IDL.Variant({ ok: IDL.Text, err: Error });
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
  const Result_11 = IDL.Variant({ ok: RewardRates, err: Error });
  const AppStatus = IDL.Record({ version: IDL.Text, onHold: IDL.Bool });
  const Result_10 = IDL.Variant({ ok: AppStatus, err: Error });
  const DataHash = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_9 = IDL.Variant({ ok: IDL.Vec(DataHash), err: Error });
  const SeasonId = IDL.Nat16;
  const GameweekNumber = IDL.Nat8;
  const PrincipalId = IDL.Text;
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
  const Result_8 = IDL.Variant({ ok: FantasyTeamSnapshot, err: Error });
  const CanisterId = IDL.Text;
  const Result_6 = IDL.Variant({ ok: IDL.Vec(CanisterId), err: Error });
  const GetManager = IDL.Record({ principalId: IDL.Text });
  const Gameweek = IDL.Record({
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
  const Manager = IDL.Record({
    username: IDL.Text,
    weeklyPosition: IDL.Int,
    createDate: IDL.Int,
    monthlyPoints: IDL.Int16,
    weeklyPoints: IDL.Int16,
    weeklyPositionText: IDL.Text,
    gameweeks: IDL.Vec(Gameweek),
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
  const Result_7 = IDL.Variant({ ok: Manager, err: Error });
  const GetManagerByUsername = IDL.Record({ username: IDL.Text });
  const GetPlayersMap = IDL.Record({
    seasonId: IDL.Nat16,
    gameweek: IDL.Nat8,
    leagueId: IDL.Nat16,
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
  const PlayerEventData__2 = IDL.Record({
    fixtureId: IDL.Nat32,
    clubId: IDL.Nat16,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType,
  });
  const PlayerPosition = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null,
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
    position: PlayerPosition,
    points: IDL.Int16,
  });
  const PlayersMap = IDL.Record({
    playersMap: IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScore)),
  });
  const Result_5 = IDL.Variant({ ok: PlayersMap, err: Error });
  const GetProfile = IDL.Record({ principalId: PrincipalId });
  const MembershipType__1 = IDL.Variant({
    Founding: IDL.Null,
    NotClaimed: IDL.Null,
    Seasonal: IDL.Null,
    Lifetime: IDL.Null,
    Monthly: IDL.Null,
    NotEligible: IDL.Null,
    Expired: IDL.Null,
  });
  const MembershipClaim = IDL.Record({
    expiresOn: IDL.Opt(IDL.Int),
    claimedOn: IDL.Int,
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
  const Result_4 = IDL.Variant({ ok: CombinedProfile, err: Error });
  const GetTeamSetup = IDL.Record({ principalId: IDL.Text });
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
  const Result_3 = IDL.Variant({ ok: TeamSetup, err: Error });
  const Result_2 = IDL.Variant({ ok: IDL.Nat, err: Error });
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
  const Result_1 = IDL.Variant({ ok: WeeklyLeaderboard, err: Error });
  const LinkICFCProfile = IDL.Record({
    icfcPrincipalId: PrincipalId,
    favouriteClubId: ClubId,
    icfcMembershipType: MembershipType__1,
    principalId: PrincipalId,
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
    getActiveLeaderboardCanisterId: IDL.Func([], [Result_12], []),
    getActiveRewardRates: IDL.Func([], [Result_11], []),
    getAppStatus: IDL.Func([], [Result_10], []),
    getDataHashes: IDL.Func([], [Result_9], []),
    getFantasyTeamSnapshot: IDL.Func([GetFantasyTeamSnapshot], [Result_8], []),
    getLeaderboardCanisterIds: IDL.Func([], [Result_6], []),
    getManager: IDL.Func([GetManager], [Result_7], []),
    getManagerByUsername: IDL.Func([GetManagerByUsername], [Result_7], []),
    getManagerCanisterIds: IDL.Func([], [Result_6], []),
    getPlayersMap: IDL.Func([GetPlayersMap], [Result_5], []),
    getProfile: IDL.Func([GetProfile], [Result_4], []),
    getTeamSelection: IDL.Func([GetTeamSetup], [Result_3], []),
    getTotalManagers: IDL.Func([], [Result_2], []),
    getWeeklyLeaderboard: IDL.Func([GetWeeklyLeaderboard], [Result_1], []),
    linkICFCLink: IDL.Func([LinkICFCProfile], [Result], []),
    noitifyAppofICFCHashUpdate: IDL.Func([UpdateICFCProfile], [Result], []),
    notifyAppLink: IDL.Func([NotifyAppofLink], [Result], []),
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
