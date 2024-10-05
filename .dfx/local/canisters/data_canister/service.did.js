export const idlFactory = ({ IDL }) => {
  const FixtureId = IDL.Nat32;
  const ClubId = IDL.Nat16;
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
  const SeasonId = IDL.Nat16;
  const GameweekNumber = IDL.Nat8;
  const CalendarMonth = IDL.Nat8;
  const SystemState = IDL.Record({
    pickTeamSeasonId: SeasonId,
    calculationGameweek: GameweekNumber,
    transferWindowActive: IDL.Bool,
    pickTeamMonth: CalendarMonth,
    pickTeamGameweek: GameweekNumber,
    version: IDL.Text,
    calculationMonth: CalendarMonth,
    calculationSeasonId: SeasonId,
    onHold: IDL.Bool,
    seasonActive: IDL.Bool,
  });
  const FootballLeagueId = IDL.Nat16;
  const CountryId = IDL.Nat16;
  const Gender = IDL.Variant({ Male: IDL.Null, Female: IDL.Null });
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
    gender: Gender,
    shirtNumber: IDL.Nat8,
    position: PlayerPosition,
    lastName: IDL.Text,
    firstName: IDL.Text,
  });
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
    SelectedCaptainNotInTeam: IDL.Null,
    InvalidData: IDL.Null,
    SystemOnHold: IDL.Null,
    AlreadyExists: IDL.Null,
    CanisterCreateError: IDL.Null,
    Not11Players: IDL.Null,
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const ShirtType = IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null });
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
  const Result_7 = IDL.Variant({ ok: IDL.Vec(Club), err: Error });
  const RequestFixturesDTO = IDL.Record({ seasonId: SeasonId });
  const FixtureStatusType = IDL.Variant({
    Unplayed: IDL.Null,
    Finalised: IDL.Null,
    Active: IDL.Null,
    Complete: IDL.Null,
  });
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
  const Result_3 = IDL.Variant({ ok: IDL.Vec(FixtureDTO), err: Error });
  const ClubFilterDTO = IDL.Record({
    clubId: ClubId,
    leagueId: FootballLeagueId,
  });
  const PlayerStatus = IDL.Variant({
    OnLoan: IDL.Null,
    Active: IDL.Null,
    FreeAgent: IDL.Null,
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
  const Result_2 = IDL.Variant({ ok: IDL.Vec(PlayerDTO), err: Error });
  const PlayerId = IDL.Nat16;
  const GetPlayerDetailsDTO = IDL.Record({
    playerId: PlayerId,
    seasonId: SeasonId,
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
  const Result_6 = IDL.Variant({ ok: PlayerDetailDTO, err: Error });
  const GameweekFiltersDTO = IDL.Record({
    seasonId: SeasonId,
    gameweek: GameweekNumber,
  });
  const PlayerPointsDTO = IDL.Record({
    id: IDL.Nat16,
    clubId: ClubId,
    events: IDL.Vec(PlayerEventData),
    position: PlayerPosition,
    gameweek: GameweekNumber,
    points: IDL.Int16,
  });
  const Result_5 = IDL.Variant({
    ok: IDL.Vec(PlayerPointsDTO),
    err: Error,
  });
  const RequestPlayersDTO = IDL.Record({ seasonId: SeasonId });
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
  const Result_4 = IDL.Variant({
    ok: IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO)),
    err: Error,
  });
  const SeasonDTO = IDL.Record({
    id: SeasonId,
    name: IDL.Text,
    year: IDL.Nat16,
  });
  const Result_1 = IDL.Variant({ ok: IDL.Vec(SeasonDTO), err: Error });
  const LoanPlayerDTO = IDL.Record({
    loanEndDate: IDL.Int,
    playerId: PlayerId,
    seasonId: SeasonId,
    loanClubId: ClubId,
    gameweek: GameweekNumber,
    loanLeagueId: FootballLeagueId,
  });
  const PromoteNewClubDTO = IDL.Record({
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: ShirtType,
    primaryColourHex: IDL.Text,
  });
  const RetirePlayerDTO = IDL.Record({
    playerId: PlayerId,
    retirementDate: IDL.Int,
  });
  const RevaluePlayerDownDTO = IDL.Record({
    playerId: PlayerId,
    seasonId: SeasonId,
    gameweek: GameweekNumber,
  });
  const RevaluePlayerUpDTO = IDL.Record({
    playerId: PlayerId,
    seasonId: SeasonId,
    gameweek: GameweekNumber,
  });
  const SetPlayerInjuryDTO = IDL.Record({
    playerId: PlayerId,
    description: IDL.Text,
    expectedEndDate: IDL.Int,
  });
  const TransferPlayerDTO = IDL.Record({
    clubId: ClubId,
    newLeagueId: FootballLeagueId,
    playerId: PlayerId,
    newShirtNumber: IDL.Nat8,
    seasonId: SeasonId,
    newClubId: ClubId,
    gameweek: GameweekNumber,
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
  const AddInitialFixturesDTO = IDL.Record({
    seasonFixtures: IDL.Vec(FixtureDTO),
  });
  const MoveFixtureDTO = IDL.Record({
    fixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
  });
  const PostponeFixtureDTO = IDL.Record({ fixtureId: FixtureId });
  const RecallPlayerDTO = IDL.Record({ playerId: PlayerId });
  const RescheduleFixtureDTO = IDL.Record({
    postponedFixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
  });
  const SubmitFixtureDataDTO = IDL.Record({
    fixtureId: FixtureId,
    month: CalendarMonth,
    gameweek: GameweekNumber,
    playerEventData: IDL.Vec(PlayerEventData),
  });
  return IDL.Service({
    addEventsToFixture: IDL.Func(
      [IDL.Vec(PlayerEventData), SeasonId, FixtureId],
      [],
      [],
    ),
    addEventsToPlayers: IDL.Func(
      [IDL.Vec(PlayerEventData), SeasonId, GameweekNumber],
      [],
      [],
    ),
    checkGameweekComplete: IDL.Func([SeasonId, GameweekNumber], [IDL.Bool], []),
    checkMonthComplete: IDL.Func(
      [SeasonId, CalendarMonth, GameweekNumber],
      [IDL.Bool],
      [],
    ),
    checkSeasonComplete: IDL.Func([SeasonId], [IDL.Bool], []),
    createNewSeason: IDL.Func([SystemState], [], ["oneway"]),
    createPlayer: IDL.Func([FootballLeagueId, CreatePlayerDTO], [Result], []),
    getClubs: IDL.Func([FootballLeagueId], [Result_7], []),
    getFixtures: IDL.Func(
      [FootballLeagueId, RequestFixturesDTO],
      [Result_3],
      [],
    ),
    getLoanedPlayers: IDL.Func(
      [FootballLeagueId, ClubFilterDTO],
      [Result_2],
      [],
    ),
    getPlayerDetails: IDL.Func(
      [FootballLeagueId, GetPlayerDetailsDTO],
      [Result_6],
      [],
    ),
    getPlayerDetailsForGameweek: IDL.Func(
      [FootballLeagueId, GameweekFiltersDTO],
      [Result_5],
      [],
    ),
    getPlayers: IDL.Func([FootballLeagueId, RequestPlayersDTO], [Result_2], []),
    getPlayersMap: IDL.Func(
      [FootballLeagueId, GameweekFiltersDTO],
      [Result_4],
      [],
    ),
    getPostponedFixtures: IDL.Func(
      [FootballLeagueId, RequestFixturesDTO],
      [Result_3],
      [],
    ),
    getRetiredPlayers: IDL.Func(
      [FootballLeagueId, ClubFilterDTO],
      [Result_2],
      [],
    ),
    getSeasons: IDL.Func([FootballLeagueId], [Result_1], []),
    loanPlayer: IDL.Func([FootballLeagueId, LoanPlayerDTO], [Result], []),
    promoteNewClub: IDL.Func(
      [FootballLeagueId, PromoteNewClubDTO],
      [Result],
      [],
    ),
    retirePlayer: IDL.Func([FootballLeagueId, RetirePlayerDTO], [Result], []),
    revaluePlayerDown: IDL.Func(
      [FootballLeagueId, RevaluePlayerDownDTO],
      [Result],
      [],
    ),
    revaluePlayerUp: IDL.Func(
      [FootballLeagueId, RevaluePlayerUpDTO],
      [Result],
      [],
    ),
    setFixtureToComplete: IDL.Func([SeasonId, FixtureId], [], ["oneway"]),
    setFixtureToFinalised: IDL.Func([SeasonId, FixtureId], [], ["oneway"]),
    setGameScore: IDL.Func([SeasonId, FixtureId], [], ["oneway"]),
    setPlayerInjury: IDL.Func(
      [FootballLeagueId, SetPlayerInjuryDTO],
      [Result],
      [],
    ),
    setupData: IDL.Func([], [Result], []),
    transferPlayer: IDL.Func(
      [FootballLeagueId, TransferPlayerDTO],
      [Result],
      [],
    ),
    unretirePlayer: IDL.Func([UnretirePlayerDTO], [Result], []),
    updateClub: IDL.Func([UpdateClubDTO], [Result], []),
    updatePlayer: IDL.Func([FootballLeagueId, UpdatePlayerDTO], [Result], []),
    validateAddInitialFixtures: IDL.Func(
      [FootballLeagueId, AddInitialFixturesDTO],
      [Result],
      [],
    ),
    validateCreatePlayer: IDL.Func(
      [FootballLeagueId, CreatePlayerDTO],
      [Result],
      [],
    ),
    validateLoanPlayer: IDL.Func(
      [FootballLeagueId, LoanPlayerDTO],
      [Result],
      [],
    ),
    validateMoveFixture: IDL.Func(
      [FootballLeagueId, MoveFixtureDTO],
      [Result],
      [],
    ),
    validatePostponeFixture: IDL.Func(
      [FootballLeagueId, PostponeFixtureDTO],
      [Result],
      [],
    ),
    validateRecallPlayer: IDL.Func(
      [FootballLeagueId, RecallPlayerDTO],
      [Result],
      [],
    ),
    validateRescehduleFixture: IDL.Func(
      [FootballLeagueId, RescheduleFixtureDTO],
      [Result],
      [],
    ),
    validateRetirePlayer: IDL.Func(
      [FootballLeagueId, RetirePlayerDTO],
      [Result],
      [],
    ),
    validateRevaluePlayerDown: IDL.Func(
      [FootballLeagueId, RevaluePlayerDownDTO],
      [Result],
      [],
    ),
    validateRevaluePlayerUp: IDL.Func(
      [FootballLeagueId, RevaluePlayerUpDTO],
      [Result],
      [],
    ),
    validateSetPlayerInjury: IDL.Func(
      [FootballLeagueId, SetPlayerInjuryDTO],
      [Result],
      [],
    ),
    validateSubmitFixtureData: IDL.Func(
      [FootballLeagueId, SubmitFixtureDataDTO],
      [Result],
      [],
    ),
    validateTransferPlayer: IDL.Func(
      [FootballLeagueId, TransferPlayerDTO],
      [Result],
      [],
    ),
    validateUnretirePlayer: IDL.Func(
      [FootballLeagueId, UnretirePlayerDTO],
      [Result],
      [],
    ),
    validateUpdateClub: IDL.Func(
      [FootballLeagueId, UpdateClubDTO],
      [Result],
      [],
    ),
    validateUpdatePlayer: IDL.Func(
      [FootballLeagueId, UpdatePlayerDTO],
      [Result],
      [],
    ),
  });
};
export const init = ({ IDL }) => {
  return [];
};
