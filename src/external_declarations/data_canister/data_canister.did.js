export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const List_2 = IDL.Rec();
  const List_3 = IDL.Rec();
  const List_4 = IDL.Rec();
  const List_5 = IDL.Rec();
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
  const LeagueId = IDL.Nat16;
  const AddInitialFixturesDTO = IDL.Record({
    seasonId: SeasonId,
    seasonFixtures: IDL.Vec(FixtureDTO),
    leagueId: LeagueId,
  });
  const ShirtType = IDL.Variant({ Filled: IDL.Null, Striped: IDL.Null });
  const CreateClubDTO = IDL.Record({
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
  const CreateLeagueDTO = IDL.Record({
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
  const CreatePlayerDTO = IDL.Record({
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
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotFound: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    AlreadyExists: IDL.Null,
    CanisterCreateError: IDL.Null,
    CanisterFull: IDL.Null,
  });
  const Result_2 = IDL.Variant({ ok: IDL.Vec(ClubDTO), err: Error });
  const CountryDTO = IDL.Record({
    id: CountryId,
    code: IDL.Text,
    name: IDL.Text,
  });
  const Result_11 = IDL.Variant({ ok: IDL.Vec(CountryDTO), err: Error });
  const DataHashDTO = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const Result_10 = IDL.Variant({ ok: IDL.Vec(DataHashDTO), err: Error });
  const Result_1 = IDL.Variant({ ok: IDL.Vec(FixtureDTO), err: Error });
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
  const Result_9 = IDL.Variant({ ok: LeagueStatus, err: Error });
  const FootballLeagueDTO = IDL.Record({
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
  const Result_8 = IDL.Variant({
    ok: IDL.Vec(FootballLeagueDTO),
    err: Error,
  });
  const PlayerStatus = IDL.Variant({
    OnLoan: IDL.Null,
    Active: IDL.Null,
    FreeAgent: IDL.Null,
    Retired: IDL.Null,
  });
  const LoanedPlayerDTO = IDL.Record({
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
  const Result_7 = IDL.Variant({
    ok: IDL.Vec(LoanedPlayerDTO),
    err: Error,
  });
  const GetPlayerDetailsDTO = IDL.Record({
    playerId: ClubId,
    seasonId: SeasonId,
  });
  const PlayerId = IDL.Nat16;
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
    changedOn: IDL.Int,
    newValue: IDL.Nat16,
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
  const Result = IDL.Variant({ ok: IDL.Vec(PlayerDTO), err: Error });
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
  const ClubFilterDTO = IDL.Record({
    clubId: ClubId,
    leagueId: LeagueId,
  });
  const SeasonDTO = IDL.Record({
    id: SeasonId,
    name: IDL.Text,
    year: IDL.Nat16,
  });
  const Result_3 = IDL.Variant({ ok: IDL.Vec(SeasonDTO), err: Error });
  const LoanPlayerDTO = IDL.Record({
    loanEndDate: IDL.Int,
    playerId: ClubId,
    loanClubId: ClubId,
    newValueQuarterMillions: IDL.Nat16,
    loanLeagueId: LeagueId,
    leagueId: LeagueId,
  });
  const MoveFixtureDTO = IDL.Record({
    fixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const SubmitFixtureDataDTO = IDL.Record({
    fixtureId: FixtureId,
    seasonId: SeasonId,
    gameweek: GameweekNumber,
    playerEventData: IDL.Vec(PlayerEventData),
    leagueId: LeagueId,
  });
  List_3.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List_3)));
  const PlayerGameweek = IDL.Record({
    events: List_3,
    number: GameweekNumber,
    points: IDL.Int16,
  });
  List_2.fill(IDL.Opt(IDL.Tuple(PlayerGameweek, List_2)));
  const PlayerSeason = IDL.Record({
    id: SeasonId,
    gameweeks: List_2,
    totalPoints: IDL.Int16,
  });
  List_1.fill(IDL.Opt(IDL.Tuple(PlayerSeason, List_1)));
  List.fill(IDL.Opt(IDL.Tuple(InjuryHistory, List)));
  const TransferHistory = IDL.Record({
    transferDate: IDL.Int,
    loanEndDate: IDL.Int,
    toLeagueId: LeagueId,
    toClub: ClubId,
    fromLeagueId: LeagueId,
    fromClub: ClubId,
  });
  List_4.fill(IDL.Opt(IDL.Tuple(TransferHistory, List_4)));
  List_5.fill(IDL.Opt(IDL.Tuple(ValueHistory, List_5)));
  const Player = IDL.Record({
    id: PlayerId,
    status: PlayerStatus,
    clubId: ClubId,
    parentClubId: ClubId,
    seasons: List_1,
    valueQuarterMillions: IDL.Nat16,
    dateOfBirth: IDL.Int,
    injuryHistory: List,
    transferHistory: List_4,
    nationality: CountryId,
    retirementDate: IDL.Int,
    valueHistory: List_5,
    latestInjuryEndDate: IDL.Int,
    gender: Gender,
    currentLoanEndDate: IDL.Int,
    shirtNumber: IDL.Nat8,
    parentLeagueId: LeagueId,
    position: PlayerPosition,
    lastName: IDL.Text,
    leagueId: LeagueId,
    firstName: IDL.Text,
  });
  const PostponeFixtureDTO = IDL.Record({
    fixtureId: FixtureId,
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const RecallPlayerDTO = IDL.Record({
    playerId: ClubId,
    newValueQuarterMillions: IDL.Nat16,
    leagueId: LeagueId,
  });
  const RescheduleFixtureDTO = IDL.Record({
    fixtureId: FixtureId,
    updatedFixtureGameweek: GameweekNumber,
    updatedFixtureDate: IDL.Int,
    seasonId: SeasonId,
    leagueId: LeagueId,
  });
  const RetirePlayerDTO = IDL.Record({
    playerId: ClubId,
    retirementDate: IDL.Int,
    leagueId: LeagueId,
  });
  const RevaluePlayerDownDTO = IDL.Record({
    playerId: PlayerId,
    leagueId: LeagueId,
  });
  const RevaluePlayerUpDTO = IDL.Record({
    playerId: PlayerId,
    leagueId: LeagueId,
  });
  const SetFreeAgentDTO = IDL.Record({
    playerId: ClubId,
    newValueQuarterMillions: IDL.Nat16,
    leagueId: LeagueId,
  });
  const SetPlayerInjuryDTO = IDL.Record({
    playerId: ClubId,
    description: IDL.Text,
    leagueId: LeagueId,
    expectedEndDate: IDL.Int,
  });
  const TransferPlayerDTO = IDL.Record({
    clubId: ClubId,
    newLeagueId: LeagueId,
    playerId: ClubId,
    newShirtNumber: IDL.Nat8,
    newValueQuarterMillions: IDL.Nat16,
    newClubId: ClubId,
    leagueId: LeagueId,
  });
  const UnretirePlayerDTO = IDL.Record({
    playerId: ClubId,
    newValueQuarterMillions: IDL.Nat16,
    leagueId: LeagueId,
  });
  const UpdateClubDTO = IDL.Record({
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
  const UpdateLeagueDTO = IDL.Record({
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
  const UpdatePlayerDTO = IDL.Record({
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
  const PromoteClubDTO = IDL.Record({
    clubId: ClubId,
    toLeagueId: LeagueId,
    leagueId: LeagueId,
  });
  const RelegateClubDTO = IDL.Record({
    clubId: ClubId,
    relegatedToLeagueId: LeagueId,
    leagueId: LeagueId,
  });
  return IDL.Service({
    addInitialFixtures: IDL.Func([AddInitialFixturesDTO], [], []),
    createClub: IDL.Func([CreateClubDTO], [], []),
    createLeague: IDL.Func([CreateLeagueDTO], [], []),
    createPlayer: IDL.Func([CreatePlayerDTO], [], []),
    getClubs: IDL.Func([LeagueId], [Result_2], ["query"]),
    getCountries: IDL.Func([], [Result_11], ["query"]),
    getDataHashes: IDL.Func([LeagueId], [Result_10], ["query"]),
    getFixtures: IDL.Func([LeagueId, SeasonId], [Result_1], ["query"]),
    getLeagueStatus: IDL.Func([LeagueId], [Result_9], ["query"]),
    getLeagues: IDL.Func([], [Result_8], ["query"]),
    getLoanedPlayers: IDL.Func([LeagueId], [Result_7], ["query"]),
    getPlayerDetails: IDL.Func(
      [LeagueId, GetPlayerDetailsDTO],
      [Result_6],
      ["query"],
    ),
    getPlayerDetailsForGameweek: IDL.Func(
      [LeagueId, GameweekFiltersDTO],
      [Result_5],
      ["query"],
    ),
    getPlayers: IDL.Func([LeagueId], [Result], ["query"]),
    getPlayersMap: IDL.Func(
      [LeagueId, GameweekFiltersDTO],
      [Result_4],
      ["query"],
    ),
    getPostponedFixtures: IDL.Func([LeagueId], [Result_1], ["query"]),
    getRetiredPlayers: IDL.Func([LeagueId, ClubFilterDTO], [Result], ["query"]),
    getSeasons: IDL.Func([LeagueId], [Result_3], ["query"]),
    getVerifiedClubs: IDL.Func([LeagueId], [Result_2], []),
    getVerifiedFixtures: IDL.Func([LeagueId, SeasonId], [Result_1], []),
    getVerifiedPlayers: IDL.Func([LeagueId], [Result], []),
    loanPlayer: IDL.Func([LoanPlayerDTO], [], []),
    moveFixture: IDL.Func([MoveFixtureDTO], [], []),
    populatePlayerEventData: IDL.Func(
      [SubmitFixtureDataDTO, IDL.Vec(Player)],
      [IDL.Opt(IDL.Vec(PlayerEventData))],
      [],
    ),
    postponeFixture: IDL.Func([PostponeFixtureDTO], [], []),
    recallPlayer: IDL.Func([RecallPlayerDTO], [], []),
    rescheduleFixture: IDL.Func([RescheduleFixtureDTO], [], []),
    retirePlayer: IDL.Func([RetirePlayerDTO], [], []),
    revaluePlayerDown: IDL.Func([RevaluePlayerDownDTO], [], []),
    revaluePlayerUp: IDL.Func([RevaluePlayerUpDTO], [], []),
    setFreeAgent: IDL.Func([SetFreeAgentDTO], [], []),
    setPlayerInjury: IDL.Func([SetPlayerInjuryDTO], [], []),
    submitFixtureData: IDL.Func([SubmitFixtureDataDTO], [], []),
    transferPlayer: IDL.Func([TransferPlayerDTO], [], []),
    unretirePlayer: IDL.Func([UnretirePlayerDTO], [], []),
    updateClub: IDL.Func([UpdateClubDTO], [], []),
    updateLeague: IDL.Func([UpdateLeagueDTO], [], []),
    updatePlayer: IDL.Func([UpdatePlayerDTO], [], []),
    validateAddInitialFixtures: IDL.Func(
      [AddInitialFixturesDTO],
      [RustResult],
      [],
    ),
    validateCreateClub: IDL.Func([CreateClubDTO], [RustResult], []),
    validateCreateLeague: IDL.Func([CreateLeagueDTO], [RustResult], []),
    validateCreatePlayer: IDL.Func([CreatePlayerDTO], [RustResult], []),
    validateLoanPlayer: IDL.Func([LoanPlayerDTO], [RustResult], []),
    validateMoveFixture: IDL.Func([MoveFixtureDTO], [RustResult], []),
    validatePostponeFixture: IDL.Func([PostponeFixtureDTO], [RustResult], []),
    validatePromoteClub: IDL.Func([PromoteClubDTO], [RustResult], []),
    validateRecallPlayer: IDL.Func([RecallPlayerDTO], [RustResult], []),
    validateRelegateClub: IDL.Func([RelegateClubDTO], [RustResult], []),
    validateRescheduleFixture: IDL.Func(
      [RescheduleFixtureDTO],
      [RustResult],
      [],
    ),
    validateRetirePlayer: IDL.Func([RetirePlayerDTO], [RustResult], []),
    validateRevaluePlayerDown: IDL.Func(
      [RevaluePlayerDownDTO],
      [RustResult],
      [],
    ),
    validateRevaluePlayerUp: IDL.Func([RevaluePlayerUpDTO], [RustResult], []),
    validateSetFreeAgent: IDL.Func([SetFreeAgentDTO], [RustResult], []),
    validateSetPlayerInjury: IDL.Func([SetPlayerInjuryDTO], [RustResult], []),
    validateSubmitFixtureData: IDL.Func(
      [SubmitFixtureDataDTO],
      [RustResult],
      [],
    ),
    validateTransferPlayer: IDL.Func([TransferPlayerDTO], [RustResult], []),
    validateUnretirePlayer: IDL.Func([UnretirePlayerDTO], [RustResult], []),
    validateUpdateClub: IDL.Func([UpdateClubDTO], [RustResult], []),
    validateUpdateLeague: IDL.Func([UpdateLeagueDTO], [RustResult], []),
    validateUpdatePlayer: IDL.Func([UpdatePlayerDTO], [RustResult], []),
  });
};
export const init = ({ IDL }) => {
  return [];
};
