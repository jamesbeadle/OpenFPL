export const idlFactory = ({ IDL }) => {
  const SeasonId = IDL.Nat16;
  const ClubId = IDL.Nat16;
  const GameweekNumber = IDL.Nat8;
  const InitialFixture = IDL.Record({
    awayClubId: ClubId,
    homeClubId: ClubId,
    kickOff: IDL.Int,
    gameweek: GameweekNumber,
  });
  const LeagueId = IDL.Nat16;
  const AddInitialFixtures = IDL.Record({
    seasonId: SeasonId,
    seasonFixtures: IDL.Vec(InitialFixture),
    leagueId: LeagueId,
  });
  const ShirtType = IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null });
  const CreateClub = IDL.Record({
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
    leagueId: LeagueId,
  });
  const Gender = IDL.Variant({ Male: IDL.Null, Female: IDL.Null });
  const CountryId = IDL.Nat16;
  const CreateLeague = IDL.Record({
    logo: IDL.Opt(IDL.Vec(IDL.Nat8)),
    name: IDL.Text,
    teamCount: IDL.Nat8,
    relatedGender: Gender,
    countryId: CountryId,
    abbreviation: IDL.Text,
    governingBody: IDL.Text,
    formed: IDL.Int,
  });
  const PlayerPosition = IDL.Variant({
    Goalkeeper: IDL.Null,
    Midfielder: IDL.Null,
    Forward: IDL.Null,
    Defender: IDL.Null,
  });
  const CreatePlayer = IDL.Record({
    clubId: ClubId,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    leagueId: LeagueId,
    firstName: IDL.Text,
  });
  const GetBettableFixtures = IDL.Record({ leagueId: LeagueId });
  const FixtureId = IDL.Nat32;
  const FixtureStatusType = IDL.Variant({
    Unplayed: IDL.Null,
    Finalised: IDL.Null,
    Active: IDL.Null,
    Complete: IDL.Null,
  });
  const PlayerId = IDL.Nat16;
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
    fixtureId: FixtureId,
    clubId: ClubId,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType,
  });
  const Fixture = IDL.Record({
    id: FixtureId,
    status: FixtureStatusType,
    highestScoringPlayerId: PlayerId,
    seasonId: SeasonId,
    awayClubId: ClubId,
    events: IDL.Vec(PlayerEventData__1),
    homeClubId: ClubId,
    kickOff: IDL.Int,
    homeGoals: IDL.Nat8,
    gameweek: GameweekNumber,
    awayGoals: IDL.Nat8,
  });
  const BettableFixtures = IDL.Record({
    seasonId: SeasonId,
    fixtures: IDL.Vec(Fixture),
    leagueId: LeagueId,
  });
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
  const Result_16 = IDL.Variant({ ok: BettableFixtures, err: Error });
  const GetBettableLeagues = IDL.Record({});
  const League = IDL.Record({
    id: LeagueId,
    logo: IDL.Vec(IDL.Nat8),
    name: IDL.Text,
    teamCount: IDL.Nat8,
    relatedGender: Gender,
    countryId: CountryId,
    abbreviation: IDL.Text,
    governingBody: IDL.Text,
    formed: IDL.Int,
  });
  const BettableLeagues = IDL.Record({ leagues: IDL.Vec(League) });
  const Result_15 = IDL.Variant({ ok: BettableLeagues, err: Error });
  const GetClubs = IDL.Record({ leagueId: LeagueId });
  const Club = IDL.Record({
    id: ClubId,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
  });
  const Clubs = IDL.Record({ clubs: IDL.Vec(Club), leagueId: LeagueId });
  const Result_14 = IDL.Variant({ ok: Clubs, err: Error });
  const GetCountries = IDL.Record({});
  const Country = IDL.Record({
    id: CountryId,
    code: IDL.Text,
    name: IDL.Text,
  });
  const Countries = IDL.Record({ countries: IDL.Vec(Country) });
  const Result_13 = IDL.Variant({ ok: Countries, err: Error });
  const GetDataHashes = IDL.Record({ leagueId: LeagueId });
  const DataHash = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const DataHashes = IDL.Record({ dataHashes: IDL.Vec(DataHash) });
  const Result_12 = IDL.Variant({ ok: DataHashes, err: Error });
  const GetFixtures = IDL.Record({
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const Fixtures = IDL.Record({
    seasonId: SeasonId,
    fixtures: IDL.Vec(Fixture),
    leagueId: LeagueId,
  });
  const Result_11 = IDL.Variant({ ok: Fixtures, err: Error });
  const GetLeagueStatus = IDL.Record({ leagueId: LeagueId });
  const CalendarMonth = IDL.Nat8;
  const LeagueStatus = IDL.Record({
    transferWindowEndMonth: IDL.Nat8,
    transferWindowEndDay: IDL.Nat8,
    transferWindowStartMonth: IDL.Nat8,
    transferWindowActive: IDL.Bool,
    totalGameweeks: IDL.Nat8,
    completedGameweek: GameweekNumber,
    transferWindowStartDay: IDL.Nat8,
    unplayedGameweek: GameweekNumber,
    activeMonth: CalendarMonth,
    activeSeasonId: SeasonId,
    activeGameweek: GameweekNumber,
    leagueId: LeagueId,
    seasonActive: IDL.Bool,
  });
  const Result_10 = IDL.Variant({ ok: LeagueStatus, err: Error });
  const GetLeagueTable = IDL.Record({
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const LeagueTableEntry = IDL.Record({
    won: IDL.Nat,
    homeDrawn: IDL.Nat,
    clubId: ClubId,
    awayDrawn: IDL.Nat,
    homeLost: IDL.Nat,
    played: IDL.Nat,
    scored: IDL.Nat,
    lost: IDL.Nat,
    homeWon: IDL.Nat,
    conceded: IDL.Nat,
    awayPoints: IDL.Nat,
    awayWon: IDL.Nat,
    homePoints: IDL.Nat,
    awayConceded: IDL.Nat,
    awayLost: IDL.Nat,
    awayPlayed: IDL.Nat,
    awayScored: IDL.Nat,
    homePlayed: IDL.Nat,
    position: IDL.Nat,
    homeScored: IDL.Nat,
    drawn: IDL.Nat,
    homeConceded: IDL.Nat,
    points: IDL.Nat,
  });
  const LeagueTable = IDL.Record({
    seasonId: SeasonId,
    entries: IDL.Vec(LeagueTableEntry),
    leagueId: LeagueId,
  });
  const Result_9 = IDL.Variant({ ok: LeagueTable, err: Error });
  const GetLeagues = IDL.Record({});
  const Leagues = IDL.Record({ leagues: IDL.Vec(League) });
  const Result_8 = IDL.Variant({ ok: Leagues, err: Error });
  const GetLoanedPlayers = IDL.Record({ leagueId: LeagueId });
  const PlayerStatus = IDL.Variant({
    OnLoan: IDL.Null,
    Active: IDL.Null,
    FreeAgent: IDL.Null,
    Retired: IDL.Null,
  });
  const Player = IDL.Record({
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
  const LoanedPlayers = IDL.Record({ players: IDL.Vec(Player) });
  const Result_7 = IDL.Variant({ ok: LoanedPlayers, err: Error });
  const GetPlayerDetails = IDL.Record({
    playerId: PlayerId,
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const InjuryHistory = IDL.Record({
    description: IDL.Text,
    injuryStartDate: IDL.Int,
    expectedEndDate: IDL.Int,
  });
  const PlayerEventData__2 = IDL.Record({
    fixtureId: FixtureId,
    clubId: ClubId,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType,
  });
  const PlayerGameweek = IDL.Record({
    fixtureId: FixtureId,
    events: IDL.Vec(PlayerEventData__2),
    number: IDL.Nat8,
    points: IDL.Int16,
  });
  const ValueHistory = IDL.Record({
    oldValue: IDL.Nat16,
    changedOn: IDL.Int,
    newValue: IDL.Nat16,
  });
  const DetailedPlayer = IDL.Record({
    id: PlayerId,
    status: PlayerStatus,
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
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text,
  });
  const PlayerDetails = IDL.Record({ player: DetailedPlayer });
  const Result_6 = IDL.Variant({ ok: PlayerDetails, err: Error });
  const GetPlayerDetailsForGameweek = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    leagueId: LeagueId,
  });
  const PlayerPoints = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    events: IDL.Vec(PlayerEventData__2),
    position: PlayerPosition,
    gameweek: GameweekNumber,
    points: IDL.Int16,
  });
  const PlayerDetailsForGameweek = IDL.Record({
    playerPoints: IDL.Vec(PlayerPoints),
  });
  const Result_5 = IDL.Variant({
    ok: PlayerDetailsForGameweek,
    err: Error,
  });
  const GetPlayers = IDL.Record({ leagueId: LeagueId });
  const Players = IDL.Record({ players: IDL.Vec(Player) });
  const Result_4 = IDL.Variant({ ok: Players, err: Error });
  const GetPlayersMap = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    leagueId: LeagueId,
  });
  const PlayerScore = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    assists: IDL.Int16,
    dateOfBirth: IDL.Int,
    nationality: CountryId,
    goalsScored: IDL.Int16,
    saves: IDL.Int16,
    goalsConceded: IDL.Int16,
    events: IDL.Vec(PlayerEventData__2),
    position: PlayerPosition,
    points: IDL.Int16,
  });
  const PlayersMap = IDL.Record({
    playersMap: IDL.Vec(IDL.Tuple(PlayerId, PlayerScore)),
  });
  const Result_3 = IDL.Variant({ ok: PlayersMap, err: Error });
  const GetPostponedFixtures = IDL.Record({ leagueId: LeagueId });
  const PostponedFixtures = IDL.Record({
    seasonId: SeasonId,
    fixtures: IDL.Vec(Fixture),
    leagueId: LeagueId,
  });
  const Result_2 = IDL.Variant({ ok: PostponedFixtures, err: Error });
  const GetRetiredPlayers = IDL.Record({
    clubId: ClubId,
    leagueId: LeagueId,
  });
  const RetiredPlayers = IDL.Record({ players: IDL.Vec(Player) });
  const Result_1 = IDL.Variant({ ok: RetiredPlayers, err: Error });
  const GetSeasons = IDL.Record({ leagueId: LeagueId });
  const Season = IDL.Record({
    id: IDL.Nat16,
    name: IDL.Text,
    year: IDL.Nat16,
  });
  const Seasons = IDL.Record({ seasons: IDL.Vec(Season) });
  const Result = IDL.Variant({ ok: Seasons, err: Error });
  const LoanPlayer = IDL.Record({
    loanEndDate: IDL.Int,
    playerId: ClubId,
    loanClubId: ClubId,
    newValueQuarterMillions: IDL.Nat16,
    loanLeagueId: LeagueId,
    leagueId: LeagueId,
  });
  const MoveFixture = IDL.Record({
    fixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const PostponeFixture = IDL.Record({
    fixtureId: FixtureId,
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const RecallPlayer = IDL.Record({
    playerId: ClubId,
    newValueQuarterMillions: IDL.Nat16,
    leagueId: LeagueId,
  });
  const RescheduleFixture = IDL.Record({
    fixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const RetirePlayer = IDL.Record({
    playerId: ClubId,
    retirementDate: IDL.Int,
    leagueId: LeagueId,
  });
  const RevaluePlayerDown = IDL.Record({
    playerId: PlayerId,
    leagueId: LeagueId,
  });
  const RevaluePlayerUp = IDL.Record({
    playerId: PlayerId,
    leagueId: LeagueId,
  });
  const SetFreeAgent = IDL.Record({
    playerId: ClubId,
    newValueQuarterMillions: IDL.Nat16,
    leagueId: LeagueId,
  });
  const SetPlayerInjury = IDL.Record({
    playerId: ClubId,
    description: IDL.Text,
    leagueId: LeagueId,
    expectedEndDate: IDL.Int,
  });
  const PlayerEventData = IDL.Record({
    fixtureId: FixtureId,
    clubId: ClubId,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    eventType: PlayerEventType,
  });
  const SubmitFixtureData = IDL.Record({
    fixtureId: FixtureId,
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    playerEventData: IDL.Vec(PlayerEventData),
    leagueId: LeagueId,
  });
  const TransferPlayer = IDL.Record({
    clubId: ClubId,
    newLeagueId: LeagueId,
    playerId: ClubId,
    newShirtNumber: IDL.Nat8,
    newValueQuarterMillions: IDL.Nat16,
    newClubId: ClubId,
    leagueId: LeagueId,
  });
  const UnretirePlayer = IDL.Record({
    playerId: ClubId,
    newValueQuarterMillions: IDL.Nat16,
    leagueId: LeagueId,
  });
  const UpdateClub = IDL.Record({
    clubId: ClubId,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
    leagueId: LeagueId,
  });
  const UpdateLeague = IDL.Record({
    logo: IDL.Vec(IDL.Nat8),
    name: IDL.Text,
    teamCount: IDL.Nat8,
    relatedGender: Gender,
    countryId: CountryId,
    abbreviation: IDL.Text,
    governingBody: IDL.Text,
    leagueId: LeagueId,
    formed: IDL.Int,
  });
  const UpdatePlayer = IDL.Record({
    dateOfBirth: IDL.Int,
    playerId: ClubId,
    nationality: CountryId,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    leagueId: LeagueId,
    firstName: IDL.Text,
  });
  const RustResult = IDL.Variant({ Ok: IDL.Text, Err: IDL.Text });
  const PromoteClub = IDL.Record({
    clubId: ClubId,
    toLeagueId: LeagueId,
    leagueId: LeagueId,
  });
  const RelegateClub = IDL.Record({
    clubId: ClubId,
    relegatedToLeagueId: LeagueId,
    leagueId: LeagueId,
  });
  return IDL.Service({
    addInitialFixtures: IDL.Func([AddInitialFixtures], [], []),
    createClub: IDL.Func([CreateClub], [], []),
    createLeague: IDL.Func([CreateLeague], [], []),
    createPlayer: IDL.Func([CreatePlayer], [], []),
    getBettableFixtures: IDL.Func([GetBettableFixtures], [Result_16], []),
    getBettableLeagues: IDL.Func([GetBettableLeagues], [Result_15], ["query"]),
    getClubs: IDL.Func([GetClubs], [Result_14], []),
    getCountries: IDL.Func([GetCountries], [Result_13], ["query"]),
    getDataHashes: IDL.Func([GetDataHashes], [Result_12], ["query"]),
    getFixtures: IDL.Func([GetFixtures], [Result_11], []),
    getLeagueStatus: IDL.Func([GetLeagueStatus], [Result_10], ["query"]),
    getLeagueTable: IDL.Func([GetLeagueTable], [Result_9], ["query"]),
    getLeagues: IDL.Func([GetLeagues], [Result_8], ["query"]),
    getLoanedPlayers: IDL.Func([GetLoanedPlayers], [Result_7], ["query"]),
    getPlayerDetails: IDL.Func([GetPlayerDetails], [Result_6], ["query"]),
    getPlayerDetailsForGameweek: IDL.Func(
      [GetPlayerDetailsForGameweek],
      [Result_5],
      ["query"],
    ),
    getPlayers: IDL.Func([GetPlayers], [Result_4], []),
    getPlayersMap: IDL.Func([GetPlayersMap], [Result_3], ["query"]),
    getPostponedFixtures: IDL.Func(
      [GetPostponedFixtures],
      [Result_2],
      ["query"],
    ),
    getRetiredPlayers: IDL.Func([GetRetiredPlayers], [Result_1], ["query"]),
    getSeasons: IDL.Func([GetSeasons], [Result], ["query"]),
    loanPlayer: IDL.Func([LoanPlayer], [], []),
    moveFixture: IDL.Func([MoveFixture], [], []),
    postponeFixture: IDL.Func([PostponeFixture], [], []),
    recallPlayer: IDL.Func([RecallPlayer], [], []),
    rescheduleFixture: IDL.Func([RescheduleFixture], [], []),
    retirePlayer: IDL.Func([RetirePlayer], [], []),
    revaluePlayerDown: IDL.Func([RevaluePlayerDown], [], []),
    revaluePlayerUp: IDL.Func([RevaluePlayerUp], [], []),
    setFreeAgent: IDL.Func([SetFreeAgent], [], []),
    setPlayerInjury: IDL.Func([SetPlayerInjury], [], []),
    submitFixtureData: IDL.Func([SubmitFixtureData], [], []),
    transferPlayer: IDL.Func([TransferPlayer], [], []),
    unretirePlayer: IDL.Func([UnretirePlayer], [], []),
    updateClub: IDL.Func([UpdateClub], [], []),
    updateLeague: IDL.Func([UpdateLeague], [], []),
    updatePlayer: IDL.Func([UpdatePlayer], [], []),
    validateAddInitialFixtures: IDL.Func(
      [AddInitialFixtures],
      [RustResult],
      [],
    ),
    validateCreateClub: IDL.Func([CreateClub], [RustResult], []),
    validateCreateLeague: IDL.Func([CreateLeague], [RustResult], []),
    validateCreatePlayer: IDL.Func([CreatePlayer], [RustResult], []),
    validateLoanPlayer: IDL.Func([LoanPlayer], [RustResult], []),
    validateMoveFixture: IDL.Func([MoveFixture], [RustResult], []),
    validatePostponeFixture: IDL.Func([PostponeFixture], [RustResult], []),
    validatePromoteClub: IDL.Func([PromoteClub], [RustResult], []),
    validateRecallPlayer: IDL.Func([RecallPlayer], [RustResult], []),
    validateRelegateClub: IDL.Func([RelegateClub], [RustResult], []),
    validateRescheduleFixture: IDL.Func([RescheduleFixture], [RustResult], []),
    validateRetirePlayer: IDL.Func([RetirePlayer], [RustResult], []),
    validateRevaluePlayerDown: IDL.Func([RevaluePlayerDown], [RustResult], []),
    validateRevaluePlayerUp: IDL.Func([RevaluePlayerUp], [RustResult], []),
    validateSetFreeAgent: IDL.Func([SetFreeAgent], [RustResult], []),
    validateSetPlayerInjury: IDL.Func([SetPlayerInjury], [RustResult], []),
    validateSubmitFixtureData: IDL.Func([SubmitFixtureData], [RustResult], []),
    validateTransferPlayer: IDL.Func([TransferPlayer], [RustResult], []),
    validateUnretirePlayer: IDL.Func([UnretirePlayer], [RustResult], []),
    validateUpdateClub: IDL.Func([UpdateClub], [RustResult], []),
    validateUpdateLeague: IDL.Func([UpdateLeague], [RustResult], []),
    validateUpdatePlayer: IDL.Func([UpdatePlayer], [RustResult], []),
  });
};
export const init = ({ IDL }) => {
  return [];
};
