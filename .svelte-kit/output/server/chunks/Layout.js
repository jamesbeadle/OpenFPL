import { c as create_ssr_component, d as add_attribute, a as subscribe, o as onDestroy, v as validate_component, e as escape, g as null_to_empty } from "./index2.js";
import { w as writable } from "./index.js";
import { p as page } from "./stores.js";
import { AuthClient } from "@dfinity/auth-client";
import "@dfinity/utils";
import { HttpAgent, Actor } from "@dfinity/agent";
const AUTH_MAX_TIME_TO_LIVE = BigInt(
  60 * 60 * 1e3 * 1e3 * 1e3 * 24 * 14
);
const AUTH_POPUP_WIDTH = 576;
const AUTH_POPUP_HEIGHT = 625;
const createAuthClient = () => AuthClient.create({
  idleOptions: {
    disableIdle: true,
    disableDefaultIdleCallback: true
  }
});
const popupCenter = ({
  width,
  height
}) => {
  {
    return void 0;
  }
};
let authClient;
const NNS_IC_ORG_ALTERNATIVE_ORIGIN = "https://openfpl.xyz";
const NNS_IC_APP_DERIVATION_ORIGIN = "https://bgpwv-eqaaa-aaaal-qb6eq-cai.icp0.io";
const isNnsAlternativeOrigin = () => {
  return window.location.origin === NNS_IC_ORG_ALTERNATIVE_ORIGIN;
};
const initAuthStore = () => {
  const { subscribe: subscribe2, set, update } = writable({
    identity: void 0
  });
  return {
    subscribe: subscribe2,
    sync: async () => {
      authClient = authClient ?? await createAuthClient();
      const isAuthenticated = await authClient.isAuthenticated();
      set({
        identity: isAuthenticated ? authClient.getIdentity() : null
      });
    },
    signIn: ({ domain }) => new Promise(async (resolve, reject) => {
      authClient = authClient ?? await createAuthClient();
      const identityProvider = "https://identity.ic0.app";
      await authClient?.login({
        maxTimeToLive: AUTH_MAX_TIME_TO_LIVE,
        onSuccess: () => {
          update((state) => ({
            ...state,
            identity: authClient?.getIdentity()
          }));
          resolve();
        },
        onError: reject,
        identityProvider,
        ...isNnsAlternativeOrigin() && {
          derivationOrigin: NNS_IC_APP_DERIVATION_ORIGIN
        },
        windowOpenerFeatures: popupCenter({
          width: AUTH_POPUP_WIDTH,
          height: AUTH_POPUP_HEIGHT
        })
      });
    }),
    signOut: async () => {
      const client = authClient ?? await createAuthClient();
      await client.logout();
      authClient = null;
      update((state) => ({
        ...state,
        identity: null
      }));
    }
  };
};
const authStore = initAuthStore();
const idlFactory$1 = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const List_2 = IDL.Rec();
  const SeasonId = IDL.Nat16;
  const TeamId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const PlayerEventData = IDL.Record({
    fixtureId: FixtureId,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    teamId: TeamId,
    eventType: IDL.Nat8
  });
  List.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List)));
  const GameweekNumber = IDL.Nat8;
  const Fixture = IDL.Record({
    id: IDL.Nat32,
    status: IDL.Nat8,
    awayTeamId: TeamId,
    highestScoringPlayerId: IDL.Nat16,
    homeTeamId: TeamId,
    seasonId: SeasonId,
    events: List,
    kickOff: IDL.Int,
    homeGoals: IDL.Nat8,
    gameweek: GameweekNumber,
    awayGoals: IDL.Nat8
  });
  const Error = IDL.Variant({
    DecodeError: IDL.Null,
    NotAllowed: IDL.Null,
    NotFound: IDL.Null,
    NotAuthorized: IDL.Null,
    InvalidData: IDL.Null,
    AlreadyExists: IDL.Null,
    InvalidTeamError: IDL.Null
  });
  const Result = IDL.Variant({ ok: IDL.Null, err: Error });
  const PlayerId = IDL.Nat16;
  const AccountBalanceDTO = IDL.Record({
    icpBalance: IDL.Nat64,
    fplBalance: IDL.Nat64
  });
  const LeaderboardEntry = IDL.Record({
    username: IDL.Text,
    positionText: IDL.Text,
    position: IDL.Int,
    principalId: IDL.Text,
    points: IDL.Int16
  });
  const PaginatedClubLeaderboard = IDL.Record({
    month: IDL.Nat8,
    clubId: TeamId,
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry)
  });
  const DataCache = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const FantasyTeam = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    teamName: IDL.Text,
    goalGetterPlayerId: PlayerId,
    favouriteTeamId: TeamId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    teamBoostTeamId: TeamId,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    passMasterGameweek: GameweekNumber,
    goalGetterGameweek: GameweekNumber,
    bankBalance: IDL.Nat,
    captainFantasticPlayerId: PlayerId,
    noEntryGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: PlayerId
  });
  const FantasyTeamSnapshot = IDL.Record({
    playerIds: IDL.Vec(PlayerId),
    teamName: IDL.Text,
    goalGetterPlayerId: PlayerId,
    favouriteTeamId: TeamId,
    hatTrickHeroGameweek: GameweekNumber,
    transfersAvailable: IDL.Nat8,
    teamBoostGameweek: GameweekNumber,
    captainFantasticGameweek: GameweekNumber,
    teamBoostTeamId: TeamId,
    noEntryPlayerId: PlayerId,
    safeHandsPlayerId: PlayerId,
    braceBonusGameweek: GameweekNumber,
    passMasterGameweek: GameweekNumber,
    goalGetterGameweek: GameweekNumber,
    bankBalance: IDL.Nat,
    captainFantasticPlayerId: PlayerId,
    gameweek: GameweekNumber,
    noEntryGameweek: GameweekNumber,
    safeHandsGameweek: GameweekNumber,
    principalId: IDL.Text,
    passMasterPlayerId: PlayerId,
    captainId: IDL.Nat16,
    points: IDL.Int16
  });
  const FixtureDTO = IDL.Record({
    id: IDL.Nat32,
    status: IDL.Nat8,
    awayTeamId: TeamId,
    highestScoringPlayerId: IDL.Nat16,
    homeTeamId: TeamId,
    seasonId: SeasonId,
    events: IDL.Vec(PlayerEventData),
    kickOff: IDL.Int,
    homeGoals: IDL.Nat8,
    gameweek: GameweekNumber,
    awayGoals: IDL.Nat8
  });
  const ManagerDTO = IDL.Record({
    favouriteTeamId: TeamId,
    displayName: IDL.Text,
    weeklyPosition: IDL.Int,
    createDate: IDL.Int,
    monthlyPoints: IDL.Int16,
    weeklyPoints: IDL.Int16,
    weeklyPositionText: IDL.Text,
    gameweeks: IDL.Vec(FantasyTeamSnapshot),
    monthlyPosition: IDL.Int,
    seasonPosition: IDL.Int,
    monthlyPositionText: IDL.Text,
    profilePicture: IDL.Vec(IDL.Nat8),
    seasonPoints: IDL.Int16,
    principalId: IDL.Text,
    seasonPositionText: IDL.Text
  });
  const ProfileDTO = IDL.Record({
    icpDepositAddress: IDL.Vec(IDL.Nat8),
    favouriteTeamId: IDL.Nat16,
    displayName: IDL.Text,
    fplDepositAddress: IDL.Vec(IDL.Nat8),
    createDate: IDL.Int,
    canUpdateFavouriteTeam: IDL.Bool,
    reputation: IDL.Nat32,
    profilePicture: IDL.Vec(IDL.Nat8),
    membershipType: IDL.Nat8,
    principalId: IDL.Text
  });
  const PaginatedLeaderboard = IDL.Record({
    totalEntries: IDL.Nat,
    seasonId: SeasonId,
    entries: IDL.Vec(LeaderboardEntry),
    gameweek: GameweekNumber
  });
  const SeasonDTO = IDL.Record({
    id: SeasonId,
    name: IDL.Text,
    year: IDL.Nat16
  });
  List_2.fill(IDL.Opt(IDL.Tuple(Fixture, List_2)));
  const Gameweek = IDL.Record({
    number: GameweekNumber,
    fixtures: List_2,
    canisterId: IDL.Text
  });
  List_1.fill(IDL.Opt(IDL.Tuple(Gameweek, List_1)));
  const Season = IDL.Record({
    id: IDL.Nat16,
    postponedFixtures: List_2,
    name: IDL.Text,
    year: IDL.Nat16,
    gameweeks: List_1
  });
  const SystemState = IDL.Record({
    activeMonth: IDL.Nat8,
    focusGameweek: GameweekNumber,
    activeSeason: Season,
    activeGameweek: GameweekNumber
  });
  const Team = IDL.Record({
    id: IDL.Nat16,
    secondaryColourHex: IDL.Text,
    name: IDL.Text,
    friendlyName: IDL.Text,
    thirdColourHex: IDL.Text,
    abbreviatedName: IDL.Text,
    shirtType: IDL.Nat8,
    primaryColourHex: IDL.Text
  });
  const TimerInfo = IDL.Record({
    id: IDL.Int,
    fixtureId: FixtureId,
    playerId: PlayerId,
    callbackName: IDL.Text,
    triggerTime: IDL.Int
  });
  const UpdateSystemStateDTO = IDL.Record({
    activeSeasonId: SeasonId,
    activeGameweek: GameweekNumber
  });
  return IDL.Service({
    createProfile: IDL.Func([], [], []),
    executeAddInitialFixtures: IDL.Func(
      [SeasonId, IDL.Vec(Fixture)],
      [Result],
      []
    ),
    executeCreatePlayer: IDL.Func(
      [
        TeamId,
        IDL.Nat8,
        IDL.Text,
        IDL.Text,
        IDL.Nat8,
        IDL.Nat,
        IDL.Int,
        IDL.Text
      ],
      [Result],
      []
    ),
    executeLoanPlayer: IDL.Func([PlayerId, TeamId, IDL.Int], [Result], []),
    executePromoteFormerTeam: IDL.Func([TeamId], [Result], []),
    executePromoteNewTeam: IDL.Func(
      [IDL.Text, IDL.Text, IDL.Text, IDL.Text, IDL.Text, IDL.Text, IDL.Nat8],
      [Result],
      []
    ),
    executeRecallPlayer: IDL.Func([PlayerId], [Result], []),
    executeRescheduleFixture: IDL.Func(
      [FixtureId, GameweekNumber, GameweekNumber, IDL.Int],
      [Result],
      []
    ),
    executeRetirePlayer: IDL.Func([PlayerId, IDL.Int], [Result], []),
    executeRevaluePlayerDown: IDL.Func(
      [SeasonId, GameweekNumber, PlayerId],
      [Result],
      []
    ),
    executeRevaluePlayerUp: IDL.Func([PlayerId], [Result], []),
    executeSetPlayerInjury: IDL.Func(
      [PlayerId, IDL.Text, IDL.Int],
      [Result],
      []
    ),
    executeSubmitFixtureData: IDL.Func(
      [FixtureId, IDL.Vec(PlayerEventData)],
      [Result],
      []
    ),
    executeTransferPlayer: IDL.Func([PlayerId, TeamId], [Result], []),
    executeUnretirePlayer: IDL.Func([PlayerId], [Result], []),
    executeUpdatePlayer: IDL.Func(
      [PlayerId, IDL.Nat8, IDL.Text, IDL.Text, IDL.Nat8, IDL.Int, IDL.Text],
      [Result],
      []
    ),
    executeUpdateTeam: IDL.Func(
      [
        TeamId,
        IDL.Text,
        IDL.Text,
        IDL.Text,
        IDL.Text,
        IDL.Text,
        IDL.Text,
        IDL.Nat8
      ],
      [Result],
      []
    ),
    getAccountBalanceDTO: IDL.Func([], [AccountBalanceDTO], []),
    getActiveFixtures: IDL.Func([], [IDL.Vec(Fixture)], ["query"]),
    getClubLeaderboard: IDL.Func(
      [IDL.Nat16, IDL.Nat8, TeamId, IDL.Nat, IDL.Nat],
      [PaginatedClubLeaderboard],
      ["query"]
    ),
    getClubLeaderboardsCache: IDL.Func(
      [IDL.Nat16, IDL.Nat8],
      [IDL.Vec(PaginatedClubLeaderboard)],
      ["query"]
    ),
    getDataHashes: IDL.Func([], [IDL.Vec(DataCache)], ["query"]),
    getFantasyTeam: IDL.Func([], [FantasyTeam], ["query"]),
    getFantasyTeamForGameweek: IDL.Func(
      [IDL.Text, IDL.Nat16, IDL.Nat8],
      [FantasyTeamSnapshot],
      ["query"]
    ),
    getFixtureDTOs: IDL.Func([], [IDL.Vec(FixtureDTO)], ["query"]),
    getFixtures: IDL.Func([], [IDL.Vec(Fixture)], ["query"]),
    getFixturesForSeason: IDL.Func([SeasonId], [IDL.Vec(Fixture)], ["query"]),
    getManager: IDL.Func(
      [IDL.Text, SeasonId, GameweekNumber],
      [ManagerDTO],
      ["query"]
    ),
    getProfileDTO: IDL.Func([], [IDL.Opt(ProfileDTO)], ["query"]),
    getPublicProfileDTO: IDL.Func([IDL.Text], [ProfileDTO], ["query"]),
    getSeasonLeaderboard: IDL.Func(
      [IDL.Nat16, IDL.Nat, IDL.Nat],
      [PaginatedLeaderboard],
      ["query"]
    ),
    getSeasonLeaderboardCache: IDL.Func(
      [IDL.Nat16],
      [PaginatedLeaderboard],
      ["query"]
    ),
    getSeasons: IDL.Func([], [IDL.Vec(SeasonDTO)], ["query"]),
    getSystemState: IDL.Func([], [SystemState], ["query"]),
    getTeamValueInfo: IDL.Func([], [IDL.Vec(IDL.Text)], []),
    getTeams: IDL.Func([], [IDL.Vec(Team)], ["query"]),
    getTimers: IDL.Func([], [IDL.Vec(TimerInfo)], []),
    getTotalManagers: IDL.Func([], [IDL.Nat], ["query"]),
    getWeeklyLeaderboard: IDL.Func(
      [IDL.Nat16, IDL.Nat8, IDL.Nat, IDL.Nat],
      [PaginatedLeaderboard],
      ["query"]
    ),
    getWeeklyLeaderboardCache: IDL.Func(
      [IDL.Nat16, IDL.Nat8],
      [PaginatedLeaderboard],
      ["query"]
    ),
    isDisplayNameValid: IDL.Func([IDL.Text], [IDL.Bool], ["query"]),
    saveFantasyTeam: IDL.Func(
      [IDL.Vec(IDL.Nat16), IDL.Nat16, IDL.Nat8, IDL.Nat16, IDL.Nat16],
      [Result],
      []
    ),
    savePlayerEvents: IDL.Func([FixtureId, IDL.Vec(PlayerEventData)], [], []),
    updateDisplayName: IDL.Func([IDL.Text], [Result], []),
    updateFavouriteTeam: IDL.Func([IDL.Nat16], [Result], []),
    updateHashForCategory: IDL.Func([IDL.Text], [], []),
    updateProfilePicture: IDL.Func([IDL.Vec(IDL.Nat8)], [Result], []),
    updateSystemState: IDL.Func([UpdateSystemStateDTO], [Result], []),
    updateTeamValueInfo: IDL.Func([], [], []),
    validateAddInitialFixtures: IDL.Func(
      [SeasonId, IDL.Vec(Fixture)],
      [Result],
      []
    ),
    validateCreatePlayer: IDL.Func(
      [
        TeamId,
        IDL.Nat8,
        IDL.Text,
        IDL.Text,
        IDL.Nat8,
        IDL.Nat,
        IDL.Int,
        IDL.Text
      ],
      [Result],
      []
    ),
    validateLoanPlayer: IDL.Func([PlayerId, TeamId, IDL.Int], [Result], []),
    validatePromoteFormerTeam: IDL.Func([TeamId], [Result], []),
    validatePromoteNewTeam: IDL.Func(
      [IDL.Text, IDL.Text, IDL.Text, IDL.Text, IDL.Text, IDL.Text],
      [Result],
      []
    ),
    validateRecallPlayer: IDL.Func([PlayerId], [Result], []),
    validateRescheduleFixtures: IDL.Func(
      [FixtureId, GameweekNumber, GameweekNumber, IDL.Int],
      [Result],
      []
    ),
    validateRetirePlayer: IDL.Func([PlayerId, IDL.Int], [Result], []),
    validateRevaluePlayerDown: IDL.Func([PlayerId], [Result], []),
    validateRevaluePlayerUp: IDL.Func([PlayerId], [Result], []),
    validateSetPlayerInjury: IDL.Func(
      [PlayerId, IDL.Text, IDL.Int],
      [Result],
      []
    ),
    validateSubmitFixtureData: IDL.Func(
      [FixtureId, IDL.Vec(PlayerEventData)],
      [Result],
      []
    ),
    validateTransferPlayer: IDL.Func([PlayerId, TeamId], [Result], []),
    validateUnretirePlayer: IDL.Func([PlayerId], [Result], []),
    validateUpdatePlayer: IDL.Func(
      [PlayerId, IDL.Nat8, IDL.Text, IDL.Text, IDL.Nat8, IDL.Int, IDL.Text],
      [Result],
      []
    ),
    validateUpdateTeam: IDL.Func(
      [TeamId, IDL.Text, IDL.Text, IDL.Text, IDL.Text, IDL.Text, IDL.Text],
      [Result],
      []
    ),
    withdrawICP: IDL.Func([IDL.Float64, IDL.Text], [Result], [])
  });
};
const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const List_1 = IDL.Rec();
  const List_2 = IDL.Rec();
  const List_3 = IDL.Rec();
  const List_4 = IDL.Rec();
  const List_5 = IDL.Rec();
  const TeamId = IDL.Nat16;
  const SeasonId = IDL.Nat16;
  const FixtureId = IDL.Nat32;
  const PlayerEventData = IDL.Record({
    fixtureId: FixtureId,
    playerId: IDL.Nat16,
    eventStartMinute: IDL.Nat8,
    eventEndMinute: IDL.Nat8,
    teamId: TeamId,
    eventType: IDL.Nat8
  });
  List_3.fill(IDL.Opt(IDL.Tuple(PlayerEventData, List_3)));
  const GameweekNumber = IDL.Nat8;
  const Fixture = IDL.Record({
    id: IDL.Nat32,
    status: IDL.Nat8,
    awayTeamId: TeamId,
    highestScoringPlayerId: IDL.Nat16,
    homeTeamId: TeamId,
    seasonId: SeasonId,
    events: List_3,
    kickOff: IDL.Int,
    homeGoals: IDL.Nat8,
    gameweek: GameweekNumber,
    awayGoals: IDL.Nat8
  });
  const PlayerDTO = IDL.Record({
    id: IDL.Nat16,
    value: IDL.Nat,
    dateOfBirth: IDL.Int,
    nationality: IDL.Text,
    shirtNumber: IDL.Nat8,
    totalPoints: IDL.Int16,
    teamId: IDL.Nat16,
    position: IDL.Nat8,
    lastName: IDL.Text,
    firstName: IDL.Text
  });
  const PlayerScoreDTO = IDL.Record({
    id: IDL.Nat16,
    assists: IDL.Int16,
    goalsScored: IDL.Int16,
    saves: IDL.Int16,
    goalsConceded: IDL.Int16,
    events: List_3,
    teamId: IDL.Nat16,
    position: IDL.Nat8,
    points: IDL.Int16
  });
  const DataCache = IDL.Record({ hash: IDL.Text, category: IDL.Text });
  const PlayerId = IDL.Nat16;
  const PlayerGameweek = IDL.Record({
    events: List_3,
    number: IDL.Nat8,
    points: IDL.Int16
  });
  List_2.fill(IDL.Opt(IDL.Tuple(PlayerGameweek, List_2)));
  const PlayerSeason = IDL.Record({ id: IDL.Nat16, gameweeks: List_2 });
  List_1.fill(IDL.Opt(IDL.Tuple(PlayerSeason, List_1)));
  const InjuryHistory = IDL.Record({
    description: IDL.Text,
    injuryStartDate: IDL.Int,
    expectedEndDate: IDL.Int
  });
  List.fill(IDL.Opt(IDL.Tuple(InjuryHistory, List)));
  const TransferHistory = IDL.Record({
    transferDate: IDL.Int,
    loanEndDate: IDL.Int,
    toTeam: TeamId,
    transferSeason: SeasonId,
    fromTeam: TeamId,
    transferGameweek: GameweekNumber
  });
  List_4.fill(IDL.Opt(IDL.Tuple(TransferHistory, List_4)));
  const ValueHistory = IDL.Record({
    oldValue: IDL.Nat,
    newValue: IDL.Nat,
    seasonId: IDL.Nat16,
    gameweek: IDL.Nat8
  });
  List_5.fill(IDL.Opt(IDL.Tuple(ValueHistory, List_5)));
  const Player = IDL.Record({
    id: PlayerId,
    value: IDL.Nat,
    seasons: List_1,
    dateOfBirth: IDL.Int,
    injuryHistory: List,
    transferHistory: List_4,
    isInjured: IDL.Bool,
    nationality: IDL.Text,
    retirementDate: IDL.Int,
    valueHistory: List_5,
    shirtNumber: IDL.Nat8,
    teamId: TeamId,
    position: IDL.Nat8,
    parentTeamId: IDL.Nat16,
    lastName: IDL.Text,
    onLoan: IDL.Bool,
    firstName: IDL.Text
  });
  const PlayerGameweekDTO = IDL.Record({
    fixtureId: FixtureId,
    events: IDL.Vec(PlayerEventData),
    number: IDL.Nat8,
    points: IDL.Int16
  });
  const PlayerDetailDTO = IDL.Record({
    id: PlayerId,
    value: IDL.Nat,
    dateOfBirth: IDL.Int,
    injuryHistory: IDL.Vec(InjuryHistory),
    seasonId: SeasonId,
    isInjured: IDL.Bool,
    gameweeks: IDL.Vec(PlayerGameweekDTO),
    nationality: IDL.Text,
    retirementDate: IDL.Int,
    valueHistory: IDL.Vec(ValueHistory),
    shirtNumber: IDL.Nat8,
    teamId: TeamId,
    position: IDL.Nat8,
    parentTeamId: IDL.Nat16,
    lastName: IDL.Text,
    onLoan: IDL.Bool,
    firstName: IDL.Text
  });
  const PlayerPointsDTO = IDL.Record({
    id: IDL.Nat16,
    events: IDL.Vec(PlayerEventData),
    teamId: IDL.Nat16,
    position: IDL.Nat8,
    gameweek: GameweekNumber,
    points: IDL.Int16
  });
  return IDL.Service({
    calculatePlayerScores: IDL.Func(
      [IDL.Nat16, IDL.Nat8, Fixture],
      [Fixture],
      []
    ),
    createPlayer: IDL.Func(
      [
        TeamId,
        IDL.Nat8,
        IDL.Text,
        IDL.Text,
        IDL.Nat8,
        IDL.Nat,
        IDL.Int,
        IDL.Text
      ],
      [],
      []
    ),
    getActivePlayers: IDL.Func([], [IDL.Vec(PlayerDTO)], ["query"]),
    getAllPlayers: IDL.Func([], [IDL.Vec(PlayerDTO)], ["query"]),
    getAllPlayersMap: IDL.Func(
      [IDL.Nat16, IDL.Nat8],
      [IDL.Vec(IDL.Tuple(IDL.Nat16, PlayerScoreDTO))],
      ["query"]
    ),
    getDataHashes: IDL.Func([], [IDL.Vec(DataCache)], ["query"]),
    getPlayer: IDL.Func([IDL.Nat16], [Player], ["query"]),
    getPlayerDetails: IDL.Func(
      [IDL.Nat16, SeasonId],
      [PlayerDetailDTO],
      ["query"]
    ),
    getPlayerDetailsForGameweek: IDL.Func(
      [IDL.Nat16, IDL.Nat8],
      [IDL.Vec(PlayerPointsDTO)],
      ["query"]
    ),
    getPlayersDetailsForGameweek: IDL.Func(
      [IDL.Vec(PlayerId), IDL.Nat16, IDL.Nat8],
      [IDL.Vec(PlayerPointsDTO)],
      ["query"]
    ),
    getRetiredPlayer: IDL.Func([IDL.Text], [IDL.Vec(Player)], ["query"]),
    loanPlayer: IDL.Func(
      [PlayerId, TeamId, IDL.Int, SeasonId, GameweekNumber],
      [],
      []
    ),
    recallPlayer: IDL.Func([PlayerId], [], []),
    retirePlayer: IDL.Func([PlayerId, IDL.Int], [], []),
    revaluePlayerDown: IDL.Func(
      [PlayerId, SeasonId, GameweekNumber],
      [],
      ["oneway"]
    ),
    revaluePlayerUp: IDL.Func([PlayerId, SeasonId, GameweekNumber], [], []),
    setDefaultHashes: IDL.Func([], [], []),
    setPlayerInjury: IDL.Func([PlayerId, IDL.Text, IDL.Int], [], []),
    transferPlayer: IDL.Func(
      [PlayerId, TeamId, SeasonId, GameweekNumber],
      [],
      []
    ),
    unretirePlayer: IDL.Func([PlayerId], [], []),
    updateHashForCategory: IDL.Func([IDL.Text], [], []),
    updatePlayer: IDL.Func(
      [PlayerId, IDL.Nat8, IDL.Text, IDL.Text, IDL.Nat8, IDL.Int, IDL.Text],
      [],
      []
    ),
    updatePlayerEventDataCache: IDL.Func([], [], [])
  });
};
class ActorFactory {
  static createActor(idlFactory2, canisterId = "", identity = null, options = null) {
    const hostOptions = {
      host: "http://127.0.0.1:8080",
      identity
    };
    if (!options) {
      options = {
        agentOptions: hostOptions
      };
    } else if (!options.agentOptions) {
      options.agentOptions = hostOptions;
    } else {
      options.agentOptions.host = hostOptions.host;
    }
    const agent = new HttpAgent({ ...options.agentOptions });
    if ({ "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.NODE_ENV !== "production") {
      agent.fetchRootKey().catch((err) => {
        console.warn(
          "Unable to fetch root key. Ensure your local replica is running"
        );
        console.error(err);
      });
    }
    return Actor.createActor(idlFactory2, {
      agent,
      canisterId,
      ...options?.actorOptions
    });
  }
  static createIdentityActor(authStore2, canisterId) {
    let unsubscribe;
    return new Promise((resolve, reject) => {
      unsubscribe = authStore2.subscribe((store) => {
        if (store.identity) {
          resolve(store.identity);
        }
      });
    }).then((identity) => {
      unsubscribe();
      return ActorFactory.createActor(
        canisterId === { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ? idlFactory$1 : idlFactory,
        canisterId,
        identity
      );
    });
  }
}
function replacer(key, value) {
  if (typeof value === "bigint") {
    return value.toString();
  } else {
    return value;
  }
}
function updateTableData(fixtures, teams, selectedGameweek) {
  let tempTable = {};
  teams.forEach((team) => initTeamData(team.id, tempTable, teams));
  const relevantFixtures = fixtures.filter(
    (fixture) => fixture.fixture.status === 3 && fixture.fixture.gameweek <= selectedGameweek
  );
  relevantFixtures.forEach(({ fixture, homeTeam, awayTeam }) => {
    if (!homeTeam || !awayTeam)
      return;
    initTeamData(homeTeam.id, tempTable, teams);
    initTeamData(awayTeam.id, tempTable, teams);
    const homeStats = tempTable[homeTeam.id];
    const awayStats = tempTable[awayTeam.id];
    homeStats.played++;
    awayStats.played++;
    homeStats.goalsFor += fixture.homeGoals;
    homeStats.goalsAgainst += fixture.awayGoals;
    awayStats.goalsFor += fixture.awayGoals;
    awayStats.goalsAgainst += fixture.homeGoals;
    if (fixture.homeGoals > fixture.awayGoals) {
      homeStats.wins++;
      homeStats.points += 3;
      awayStats.losses++;
    } else if (fixture.homeGoals === fixture.awayGoals) {
      homeStats.draws++;
      awayStats.draws++;
      homeStats.points += 1;
      awayStats.points += 1;
    } else {
      awayStats.wins++;
      awayStats.points += 3;
      homeStats.losses++;
    }
  });
  return Object.values(tempTable).sort((a, b) => {
    const goalDiffA = a.goalsFor - a.goalsAgainst;
    const goalDiffB = b.goalsFor - b.goalsAgainst;
    if (b.points !== a.points)
      return b.points - a.points;
    if (goalDiffB !== goalDiffA)
      return goalDiffB - goalDiffA;
    if (b.goalsFor !== a.goalsFor)
      return b.goalsFor - a.goalsFor;
    return a.goalsAgainst - b.goalsAgainst;
  });
}
function initTeamData(teamId, table, teams) {
  if (!table[teamId]) {
    const team = teams.find((t) => t.id === teamId);
    if (team) {
      table[teamId] = {
        ...team,
        played: 0,
        wins: 0,
        draws: 0,
        losses: 0,
        goalsFor: 0,
        goalsAgainst: 0,
        points: 0
      };
    }
  }
}
function getAvailableFormations(players, team) {
  const positionCounts = { 0: 0, 1: 0, 2: 0, 3: 0 };
  team.playerIds.forEach((id) => {
    const teamPlayer = players.find((p) => p.id === id);
    if (teamPlayer) {
      positionCounts[teamPlayer.position]++;
    }
  });
  const formations = [
    "3-4-3",
    "3-5-2",
    "4-3-3",
    "4-4-2",
    "4-5-1",
    "5-4-1",
    "5-3-2"
  ];
  return formations.filter((formation) => {
    const [def, mid, fwd] = formation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));
    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce(
      (a, b) => a + b,
      0
    );
    return totalPlayers + additionalPlayersNeeded <= 11;
  });
}
function createSystemStore() {
  const { subscribe: subscribe2, set } = writable(null);
  let actor = ActorFactory.createActor(
    idlFactory$1,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "system_state";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedSystemStateData = await actor.getSystemState();
      localStorage.setItem(
        "system_state_data",
        JSON.stringify(updatedSystemStateData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
      set(updatedSystemStateData);
    } else {
      const cachedSystemStateData = localStorage.getItem("system_state_data");
      let cachedSystemState = null;
      try {
        cachedSystemState = JSON.parse(cachedSystemStateData || "{}");
      } catch (e) {
        cachedSystemState = null;
      }
      set(cachedSystemState);
    }
  }
  async function getSystemState() {
    let systemState;
    subscribe2((value) => {
      systemState = value;
    })();
    return systemState;
  }
  async function updateSystemState(systemState) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.updateSystemState(systemState);
      sync();
      return result;
    } catch (error) {
      console.error("Error updating system state:", error);
      throw error;
    }
  }
  return {
    subscribe: subscribe2,
    sync,
    getSystemState,
    updateSystemState
  };
}
const systemStore = createSystemStore();
function createFixtureStore() {
  const { subscribe: subscribe2, set } = writable([]);
  const actor = ActorFactory.createActor(
    idlFactory$1,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "fixtures";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedFixturesData = await actor.getFixtures();
      localStorage.setItem(
        "fixtures_data",
        JSON.stringify(updatedFixturesData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
      set(updatedFixturesData);
    } else {
      const cachedFixturesData = localStorage.getItem("fixtures_data");
      let cachedFixtures = [];
      try {
        cachedFixtures = JSON.parse(cachedFixturesData || "[]");
      } catch (e) {
        cachedFixtures = [];
      }
      set(cachedFixtures);
    }
  }
  async function getNextFixture() {
    let fixtures = [];
    await sync();
    await subscribe2((value) => {
      fixtures = value;
    })();
    const now = /* @__PURE__ */ new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1e6) > now
    );
  }
  return {
    subscribe: subscribe2,
    sync,
    getNextFixture
  };
}
const fixtureStore = createFixtureStore();
function createTeamStore() {
  const { subscribe: subscribe2, set } = writable([]);
  const actor = ActorFactory.createActor(
    idlFactory$1,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    const category = "teams";
    const newHashValues = await actor.getDataHashes();
    const liveTeamsHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveTeamsHash?.hash != localHash) {
      const updatedTeamsData = await actor.getTeams();
      localStorage.setItem(
        "teams_data",
        JSON.stringify(updatedTeamsData, replacer)
      );
      localStorage.setItem(category, liveTeamsHash?.hash ?? "");
      set(updatedTeamsData);
    } else {
      const cachedTeamsData = localStorage.getItem("teams_data");
      let cachedTeams = [];
      try {
        cachedTeams = JSON.parse(cachedTeamsData || "[]");
      } catch (e) {
        cachedTeams = [];
      }
      set(cachedTeams);
    }
  }
  async function getTeamById(id) {
    let teams = [];
    subscribe2((value) => {
      teams = value;
    })();
    return teams.find((team) => team.id === id);
  }
  return {
    subscribe: subscribe2,
    sync,
    getTeamById
  };
}
createTeamStore();
function createLeaderboardStore() {
  const { subscribe: subscribe2, set } = writable(null);
  const itemsPerPage = 25;
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let actor = ActorFactory.createActor(
    idlFactory$1,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function syncWeeklyLeaderboard() {
    let category = "weekly_leaderboard";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getWeeklyLeaderboardCache(
        systemState?.activeSeason.id,
        systemState?.focusGameweek
      );
      localStorage.setItem(
        "weekly_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }
  async function syncMonthlyLeaderboards() {
    let category = "monthly_leaderboards";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getClubLeaderboardsCache(
        systemState?.activeSeason.id,
        systemState?.activeMonth
      );
      localStorage.setItem(
        "monthly_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }
  async function syncSeasonLeaderboard() {
    let category = "season_leaderboard";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getSeasonLeaderboardCache(
        systemState?.activeSeason.id
      );
      localStorage.setItem(
        "season_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }
  async function getWeeklyLeaderboard() {
    const cachedWeeklyLeaderboardData = localStorage.getItem(
      "weekly_leaderboard_data"
    );
    let cachedWeeklyLeaderboard;
    try {
      cachedWeeklyLeaderboard = JSON.parse(
        cachedWeeklyLeaderboardData || "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
      );
    } catch (e) {
      cachedWeeklyLeaderboard = {
        entries: [],
        gameweek: 0,
        seasonId: 0,
        totalEntries: 0n
      };
    }
    return cachedWeeklyLeaderboard;
  }
  async function getWeeklyLeaderboardPage(gameweek, currentPage) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("weekly_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboard = JSON.parse(cachedData);
        return {
          entries: cachedLeaderboard.entries.slice(offset, offset + limit),
          gameweek: cachedLeaderboard.gameweek,
          seasonId: cachedLeaderboard.seasonId,
          totalEntries: cachedLeaderboard.totalEntries
        };
      }
    }
    let leaderboardData = await actor.getWeeklyLeaderboard(
      systemState?.activeSeason.id,
      gameweek,
      limit,
      offset
    );
    return leaderboardData;
  }
  async function getMonthlyLeaderboard(clubId, month, currentPage) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("monthly_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboards = JSON.parse(cachedData);
        let clubLeaderboard = cachedLeaderboards.find(
          (x) => x.clubId === clubId
        );
        if (clubLeaderboard) {
          return {
            ...clubLeaderboard,
            entries: clubLeaderboard.entries.slice(offset, offset + limit)
          };
        }
      }
    }
    let leaderboardData = await actor.getClubLeaderboard(
      systemState?.activeSeason.id,
      month,
      clubId,
      limit,
      offset
    );
    return leaderboardData;
  }
  async function getSeasonLeaderboardPage(currentPage) {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("season_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboard = JSON.parse(cachedData);
        return {
          ...cachedLeaderboard,
          entries: cachedLeaderboard.entries.slice(offset, offset + limit)
        };
      }
    }
    let leaderboardData = await actor.getSeasonLeaderboard(
      systemState?.activeSeason.id,
      limit,
      offset
    );
    return leaderboardData;
  }
  async function getLeadingWeeklyTeam() {
    let weeklyLeaderboard = await getWeeklyLeaderboard();
    return weeklyLeaderboard.entries[0];
  }
  return {
    subscribe: subscribe2,
    syncWeeklyLeaderboard,
    syncMonthlyLeaderboards,
    syncSeasonLeaderboard,
    getWeeklyLeaderboard,
    getWeeklyLeaderboardPage,
    getMonthlyLeaderboard,
    getSeasonLeaderboardPage,
    getLeadingWeeklyTeam
  };
}
createLeaderboardStore();
function createToastStore() {
  const { subscribe: subscribe2, set, update } = writable({
    visible: false,
    message: "",
    type: "success"
  });
  function show(message, type = "success") {
    update(() => ({ visible: true, message, type }));
    setTimeout(
      () => set({ visible: false, message: "", type: "success" }),
      3e3
    );
  }
  return { subscribe: subscribe2, show };
}
const toastStore = createToastStore();
const isLoading = writable(true);
const loadingText = writable("Loading");
function createPlayerStore() {
  const { subscribe: subscribe2, set } = writable([]);
  systemStore.subscribe((value) => {
  });
  fixtureStore.subscribe((value) => value);
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.PLAYER_CANISTER_CANISTER_ID
  );
  async function sync() {
    let category = "players";
    const newHashValues = await actor.getDataHashes();
    let livePlayersHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (livePlayersHash?.hash != localHash) {
      let updatedPlayersData = await actor.getAllPlayers();
      localStorage.setItem(
        "players_data",
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
      set(updatedPlayersData);
    } else {
      const cachedPlayersData = localStorage.getItem("players_data");
      let cachedPlayers = [];
      try {
        cachedPlayers = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayers = [];
      }
      set(cachedPlayers);
    }
  }
  return {
    subscribe: subscribe2,
    sync
  };
}
const playerStore = createPlayerStore();
function createPlayerEventsStore() {
  const { subscribe: subscribe2, set } = writable([]);
  let systemState;
  systemStore.subscribe((value) => {
    systemState = value;
  });
  let allFixtures;
  fixtureStore.subscribe((value) => allFixtures = value);
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.PLAYER_CANISTER_CANISTER_ID
  );
  async function sync() {
    let category = "playerEventData";
    const newHashValues = await actor.getDataHashes();
    let livePlayersHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (livePlayersHash?.hash != localHash) {
      let updatedPlayerEventsData = await actor.getPlayerDetailsForGameweek(
        systemState.activeSeason.id,
        systemState.focusGameweek
      );
      localStorage.setItem(
        "player_events_data",
        JSON.stringify(updatedPlayerEventsData, replacer)
      );
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
      set(updatedPlayerEventsData);
    } else {
      const cachedPlayersData = localStorage.getItem("player_events_data");
      let cachedPlayerEvents = [];
      try {
        cachedPlayerEvents = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayerEvents = [];
      }
      set(cachedPlayerEvents);
    }
  }
  async function getPlayerEvents() {
    const cachedPlayerEventsData = localStorage.getItem("player_events_data");
    let cachedPlayerEvents;
    try {
      cachedPlayerEvents = JSON.parse(cachedPlayerEventsData || "[]");
    } catch (e) {
      cachedPlayerEvents = [];
    }
    return cachedPlayerEvents;
  }
  async function getPlayerDetails(playerId, seasonId) {
    try {
      const playerDetailData = await actor.getPlayerDetails(playerId, seasonId);
      return playerDetailData;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }
  async function getGameweekPlayers(fantasyTeam, gameweek) {
    await sync();
    let allPlayerEvents = [];
    if (systemState?.focusGameweek === gameweek) {
      allPlayerEvents = await getPlayerEvents();
    } else {
      allPlayerEvents = await actor.getPlayersDetailsForGameweek(
        fantasyTeam.playerIds,
        systemState?.activeSeason.id,
        gameweek
      );
    }
    let allPlayers = [];
    const unsubscribe = playerStore.subscribe((players) => {
      allPlayers = players.filter(
        (player) => fantasyTeam.playerIds.includes(player.id)
      );
    });
    unsubscribe();
    let gameweekData = await Promise.all(
      allPlayers.map(
        async (player) => await extractPlayerData(
          allPlayerEvents.find((x) => x.id == player.id),
          player
        )
      )
    );
    const playersWithPoints = gameweekData.map((entry) => {
      const score = calculatePlayerScore(entry, allFixtures);
      const bonusPoints = calculateBonusPoints(entry, fantasyTeam, score);
      const captainPoints = entry.player.id === fantasyTeam.captainId ? score + bonusPoints : 0;
      return {
        ...entry,
        points: score,
        bonusPoints,
        totalPoints: score + bonusPoints + captainPoints
      };
    });
    return await Promise.all(playersWithPoints);
  }
  async function extractPlayerData(playerPointsDTO, player) {
    let goals = 0, assists = 0, redCards = 0, yellowCards = 0, missedPenalties = 0, ownGoals = 0, saves = 0, cleanSheets = 0, penaltySaves = 0, goalsConceded = 0, appearance = 0, highestScoringPlayerId = 0;
    let goalPoints = 0, assistPoints = 0, goalsConcededPoints = 0, cleanSheetPoints = 0;
    playerPointsDTO.events.forEach((event) => {
      switch (event.eventType) {
        case 0:
          appearance += 1;
          break;
        case 1:
          goals += 1;
          switch (playerPointsDTO.position) {
            case 0:
            case 1:
              goalPoints += 20;
              break;
            case 2:
              goalPoints += 15;
              break;
            case 3:
              goalPoints += 10;
              break;
          }
          break;
        case 2:
          assists += 1;
          switch (playerPointsDTO.position) {
            case 0:
            case 1:
              assistPoints += 15;
              break;
            case 2:
            case 3:
              assistPoints += 10;
              break;
          }
          break;
        case 3:
          goalsConceded += 1;
          if (playerPointsDTO.position < 2 && goalsConceded % 2 === 0) {
            goalsConcededPoints += -15;
          }
          break;
        case 4:
          saves += 1;
          break;
        case 5:
          cleanSheets += 1;
          if (playerPointsDTO.position < 2 && goalsConceded === 0) {
            cleanSheetPoints += 10;
          }
          break;
        case 6:
          penaltySaves += 1;
          break;
        case 7:
          missedPenalties += 1;
          break;
        case 8:
          yellowCards += 1;
          break;
        case 9:
          redCards += 1;
          break;
        case 10:
          ownGoals += 1;
          break;
        case 11:
          highestScoringPlayerId += 1;
          break;
      }
    });
    let playerGameweekDetails = {
      player,
      points: playerPointsDTO.points,
      appearance,
      goals,
      assists,
      goalsConceded,
      saves,
      cleanSheets,
      penaltySaves,
      missedPenalties,
      yellowCards,
      redCards,
      ownGoals,
      highestScoringPlayerId,
      goalPoints,
      assistPoints,
      goalsConcededPoints,
      cleanSheetPoints,
      gameweek: playerPointsDTO.gameweek,
      bonusPoints: 0,
      totalPoints: 0
    };
    return playerGameweekDetails;
  }
  function calculatePlayerScore(gameweekData, fixtures) {
    if (!gameweekData) {
      console.error("No gameweek data found:", gameweekData);
      return 0;
    }
    let score = 0;
    let pointsForAppearance = 5;
    let pointsFor3Saves = 5;
    let pointsForPenaltySave = 20;
    let pointsForHighestScore = 25;
    let pointsForRedCard = -20;
    let pointsForPenaltyMiss = -10;
    let pointsForEach2Conceded = -15;
    let pointsForOwnGoal = -10;
    let pointsForYellowCard = -5;
    let pointsForCleanSheet = 10;
    var pointsForGoal = 0;
    var pointsForAssist = 0;
    if (gameweekData.appearance > 0) {
      score += pointsForAppearance * gameweekData.appearance;
    }
    if (gameweekData.redCards > 0) {
      score += pointsForRedCard;
    }
    if (gameweekData.missedPenalties > 0) {
      score += pointsForPenaltyMiss * gameweekData.missedPenalties;
    }
    if (gameweekData.ownGoals > 0) {
      score += pointsForOwnGoal * gameweekData.ownGoals;
    }
    if (gameweekData.yellowCards > 0) {
      score += pointsForYellowCard * gameweekData.yellowCards;
    }
    switch (gameweekData.player.position) {
      case 0:
        pointsForGoal = 20;
        pointsForAssist = 15;
        if (gameweekData.saves >= 3) {
          score += Math.floor(gameweekData.saves / 3) * pointsFor3Saves;
        }
        if (gameweekData.penaltySaves) {
          score += pointsForPenaltySave * gameweekData.penaltySaves;
        }
        if (gameweekData.cleanSheets > 0) {
          score += pointsForCleanSheet;
        }
        if (gameweekData.goalsConceded >= 2) {
          score += Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
        }
        break;
      case 1:
        pointsForGoal = 20;
        pointsForAssist = 15;
        if (gameweekData.cleanSheets > 0) {
          score += pointsForCleanSheet;
        }
        if (gameweekData.goalsConceded >= 2) {
          score += Math.floor(gameweekData.goalsConceded / 2) * pointsForEach2Conceded;
        }
        break;
      case 2:
        pointsForGoal = 15;
        pointsForAssist = 10;
        break;
      case 3:
        pointsForGoal = 10;
        pointsForAssist = 10;
        break;
    }
    const gameweekFixtures = fixtures ? fixtures.filter((fixture) => fixture.gameweek === gameweekData.gameweek) : [];
    const playerFixture = gameweekFixtures.find(
      (fixture) => (fixture.homeTeamId === gameweekData.player.teamId || fixture.awayTeamId === gameweekData.player.teamId) && fixture.highestScoringPlayerId === gameweekData.player.id
    );
    if (playerFixture) {
      score += pointsForHighestScore;
    }
    score += gameweekData.goals * pointsForGoal;
    score += gameweekData.assists * pointsForAssist;
    return score;
  }
  function calculateBonusPoints(gameweekData, fantasyTeam, points) {
    if (!gameweekData) {
      console.error("No gameweek data found:", gameweekData);
      return 0;
    }
    let bonusPoints = 0;
    var pointsForGoal = 0;
    var pointsForAssist = 0;
    switch (gameweekData.player.position) {
      case 0:
        pointsForGoal = 20;
        pointsForAssist = 15;
        break;
      case 1:
        pointsForGoal = 20;
        pointsForAssist = 15;
        break;
      case 2:
        pointsForGoal = 15;
        pointsForAssist = 10;
        break;
      case 3:
        pointsForGoal = 10;
        pointsForAssist = 10;
        break;
    }
    if (fantasyTeam.goalGetterGameweek === gameweekData.gameweek && fantasyTeam.goalGetterPlayerId === gameweekData.player.id) {
      bonusPoints = gameweekData.goals * pointsForGoal * 2;
    }
    if (fantasyTeam.passMasterGameweek === gameweekData.gameweek && fantasyTeam.passMasterPlayerId === gameweekData.player.id) {
      bonusPoints = gameweekData.assists * pointsForAssist * 2;
    }
    if (fantasyTeam.noEntryGameweek === gameweekData.gameweek && fantasyTeam.noEntryPlayerId === gameweekData.player.id && (gameweekData.player.position === 0 || gameweekData.player.position === 1) && gameweekData.cleanSheets) {
      bonusPoints = points * 2;
    }
    if (fantasyTeam.safeHandsGameweek === gameweekData.gameweek && gameweekData.player.position === 0 && gameweekData.saves >= 5) {
      bonusPoints = points * 2;
    }
    if (fantasyTeam.captainFantasticGameweek === gameweekData.gameweek && fantasyTeam.captainId === gameweekData.player.id && gameweekData.goals > 0) {
      bonusPoints = points;
    }
    if (fantasyTeam.braceBonusGameweek === gameweekData.gameweek && gameweekData.goals >= 2) {
      bonusPoints = points;
    }
    if (fantasyTeam.hatTrickHeroGameweek === gameweekData.gameweek && gameweekData.goals >= 3) {
      bonusPoints = points * 2;
    }
    if (fantasyTeam.teamBoostGameweek === gameweekData.gameweek && gameweekData.player.teamId === fantasyTeam.teamBoostTeamId) {
      bonusPoints = points;
    }
    return bonusPoints;
  }
  return {
    subscribe: subscribe2,
    sync,
    getPlayerDetails,
    getGameweekPlayers
  };
}
createPlayerEventsStore();
const OpenFPLIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 137 188"><path d="M68.8457 0C43.0009 4.21054 19.8233 14.9859 0.331561 30.5217L0.264282 30.6627V129.685L68.7784 187.97L136.528 129.685L136.543 30.6204C117.335 15.7049 94.1282 4.14474 68.8457 0ZM82.388 145.014C82.388 145.503 82.0804 145.992 81.5806 146.114L68.7784 150.329C68.5285 150.39 68.2786 150.39 68.0287 150.329L55.2265 146.114C54.7267 145.931 54.4143 145.503 54.4143 145.014V140.738C54.4143 140.31 54.6642 139.883 55.039 139.7L67.8413 133.102C68.2161 132.919 68.591 132.919 68.9658 133.102L81.768 139.7C82.1429 139.883 82.388 140.31 82.388 140.738V145.014ZM106.464 97.9137C106.464 98.3414 106.214 98.769 105.777 98.9523L96.6607 103.534C96.036 103.84 95.8486 104.573 96.1609 105.122L105.027 121.189C105.277 121.678 105.215 122.228 104.84 122.594L89.7262 137.134C89.2889 137.561 88.6641 137.561 88.1644 137.256L70.9313 125.099C70.369 124.671 70.2441 123.877 70.7439 123.327L84.4208 108.421C85.2329 107.505 84.2958 106.161 83.1713 106.527L68.7447 111.109C68.4948 111.17 68.2449 111.17 67.9951 111.109L53.6358 106.527C52.4488 106.161 51.5742 107.566 52.3863 108.421L66.0584 123.327C66.5582 123.877 66.4332 124.671 65.871 125.099L48.6379 137.256C48.1381 137.561 47.5134 137.561 47.0761 137.134L31.9671 122.533C31.5923 122.167 31.5298 121.617 31.7797 121.128L40.6461 105.061C40.9585 104.45 40.7086 103.778 40.1463 103.473L31.03 98.8912C30.6552 98.7079 30.3428 98.2803 30.3428 97.8526V65.8413C30.3428 64.9249 31.4049 64.314 32.217 64.8639L39.709 69.8122C40.0214 70.0565 40.2088 70.362 40.2088 70.7896L40.2713 79.0368C40.2713 79.4034 40.4587 79.7699 40.7711 80.0143L51.7616 87.5284C52.5737 88.0782 53.6983 87.4673 53.6358 86.4898L52.9486 71.9503C52.9486 71.5838 52.7612 71.2173 52.4488 71.034L30.8426 56.5556C30.5302 56.3112 30.3428 55.9447 30.3428 55.5781V48.4305C30.3428 48.1862 30.4053 47.8807 30.5927 47.6975L38.3971 38.0452C38.7094 37.6176 39.2717 37.4954 39.7715 37.6786L67.9326 47.8807C68.1825 48.0029 68.4948 48.0029 68.7447 47.8807L96.9106 37.6786C97.4104 37.4954 97.9679 37.6786 98.2802 38.0452L106.089 47.6975C106.277 47.8807 106.339 48.1862 106.339 48.4305V55.5781C106.339 55.9447 106.152 56.3112 105.84 56.5556L84.2333 71.034C84.0459 71.2783 83.8585 71.6449 83.8585 72.0114L83.1713 86.5509C83.1088 87.5284 84.2333 88.1393 85.0455 87.5895L96.036 80.0753C96.3484 79.831 96.5358 79.5255 96.5358 79.0979L96.5983 70.8507C96.5983 70.4842 96.7857 70.1176 97.098 69.8733L104.59 64.9249C105.402 64.3751 106.464 64.9249 106.464 65.9024V97.9137Z" fill="#fffff"></path></svg>`;
});
const WalletIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 24 24"><path d="M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v9a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 13.5v-9a1.5 1.5 0 0 1 1.432-1.499L12.136.326zM5.562 3H13V1.78a.5.5 0 0 0-.621-.484L5.562 3zM1.5 4a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-13z"></path><path d="M15.5,6.5v3a1,1,0,0,1-1,1h-3.5v-5H14.5A1,1,0,0,1,15.5,6.5Z"></path><path d="M12,8a.5,.5 0,1,1,.001,0Z"></path></svg>`;
});
const Header_svelte_svelte_type_style_lang = "";
const css$3 = {
  code: 'header.svelte-197nckd{background-color:rgba(36, 37, 41, 0.9)}.nav-underline.svelte-197nckd{position:relative;display:inline-block;color:white}.nav-underline.svelte-197nckd::after{content:"";position:absolute;width:100%;height:2px;background-color:#2ce3a6;bottom:0;left:0;transform:scaleX(0);transition:transform 0.3s ease-in-out;color:#2ce3a6}.nav-underline.svelte-197nckd:hover::after,.nav-underline.active.svelte-197nckd::after{transform:scaleX(1);color:#2ce3a6}.nav-underline.svelte-197nckd:hover::after{transform:scaleX(1);background-color:gray}.nav-button.svelte-197nckd{background-color:transparent}.nav-button.svelte-197nckd:hover{background-color:transparent;color:#2ce3a6;border:none}',
  map: null
};
const Header = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_page;
  let $$unsubscribe_isLoading;
  let $profile, $$unsubscribe_profile;
  $$unsubscribe_page = subscribe(page, (value) => value);
  $$unsubscribe_isLoading = subscribe(isLoading, (value) => value);
  let profile = writable(null);
  $$unsubscribe_profile = subscribe(profile, (value) => $profile = value);
  onDestroy(() => {
    if (typeof window !== "undefined") {
      document.removeEventListener("click", closeDropdownOnClickOutside);
    }
  });
  function closeDropdownOnClickOutside(event) {
    const target = event.target;
    if (target instanceof Element) {
      if (!target.closest(".profile-dropdown") && !target.closest(".profile-pic"))
        ;
    }
  }
  $$result.css.add(css$3);
  URL.createObjectURL(new Blob([new Uint8Array($profile?.profilePicture ?? [])]));
  $$unsubscribe_page();
  $$unsubscribe_isLoading();
  $$unsubscribe_profile();
  return `<header class="svelte-197nckd"><nav class="text-white"><div class="px-4 h-16 flex justify-between items-center w-full"><a href="/" class="hover:text-gray-400 flex items-center">${validate_component(OpenFPLIcon, "OpenFPLIcon").$$render($$result, { className: "h-8 w-auto" }, {}, {})}<b class="ml-2">OpenFPL</b></a>
      <button class="md:hidden focus:outline-none"><svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="24" height="2" rx="1" fill="currentColor"></rect><rect y="8" width="24" height="2" rx="1" fill="currentColor"></rect><rect y="16" width="24" height="2" rx="1" fill="currentColor"></rect></svg></button>
      ${`<ul class="hidden md:flex"><li class="mx-2 flex items-center h-16"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-197nckd">Connect
              ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul>
        <div class="${escape(null_to_empty(`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-197nckd"}"><ul class="flex flex-col"><li class="p-2"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-197nckd">Connect
                ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div>`}</div></nav>
</header>`;
});
const JunoIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 130 130"><g id="Layer_1-2"><g><path d="M91.99,64.798c0,-20.748 -16.845,-37.593 -37.593,-37.593l-0.003,-0c-20.749,-0 -37.594,16.845 -37.594,37.593l0,0.004c0,20.748 16.845,37.593 37.594,37.593l0.003,0c20.748,0 37.593,-16.845 37.593,-37.593l0,-0.004Z"></path><circle cx="87.153" cy="50.452" r="23.247" style="fill:#7888ff;"></circle></g></g></svg>`;
});
const Footer = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<footer class="bg-gray-900 text-white py-3"><div class="container mx-auto flex flex-col sm:flex-row items-start sm:items-center justify-between text-xs"><div class="flex-1"><div class="flex justify-start"><div class="flex flex-row pl-4"><a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer"><img src="openchat.png" class="h-4 w-auto mb-2 mr-2" alt="OpenChat"></a>
          <a href="https://twitter.com/OpenFPL_DAO" target="_blank" rel="noopener noreferrer"><img src="twitter.png" class="h-4 w-auto mb-2 mr-2" alt="Twitter"></a>
          <a href="https://t.co/WmOhFA8JUR" target="_blank" rel="noopener noreferrer"><img src="discord.png" class="h-4 w-auto mb-2 mr-2" alt="Discord"></a>
          <a href="https://t.co/vVkquMrdOu" target="_blank" rel="noopener noreferrer"><img src="telegram.png" class="h-4 w-auto mb-2 mr-2" alt="Telegram"></a>
          <a href="https://github.com/jamesbeadle/OpenFPL" target="_blank" rel="noopener noreferrer"><img src="github.png" class="h-4 w-auto mb-2" alt="GitHub"></a></div></div>
      <div class="flex justify-start"><div class="flex flex-col sm:flex-row sm:space-x-2 pl-4"><a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a>
          <span class="hidden sm:flex">|</span>
          <a href="/gameplay-rules" class="hover:text-gray-300">Gameplay Rules</a>
          <span class="hidden sm:flex">|</span>
          <a href="/terms" class="hover:text-gray-300">Terms &amp; Conditions</a></div></div></div>
    <div class="flex-0"><a href="/"><b class="px-4 mt-2 sm:mt-0 sm:px-10 flex items-center">${validate_component(OpenFPLIcon, "OpenFplIcon").$$render($$result, { className: "h-6 w-auto mr-2" }, {}, {})}OpenFPL</b></a></div>
    <div class="flex-1"><div class="flex justify-end"><div class="text-right px-4 sm:px-0 mt-1 sm:mt-0 md:mr-4"><a href="https://juno.build" target="_blank" class="hover:text-gray-300 flex items-center">Sponsored By juno.build
            ${validate_component(JunoIcon, "JunoIcon").$$render($$result, { className: "h-8 w-auto ml-2" }, {}, {})}</a></div></div></div></div></footer>`;
});
const toast_svelte_svelte_type_style_lang = "";
const css$2 = {
  code: "@keyframes svelte-1pzngus-fadeIn{from{opacity:0}to{opacity:1}}@keyframes svelte-1pzngus-fadeOut{from{opacity:1}to{opacity:0}}.toast-panel.svelte-1pzngus{animation-name:svelte-1pzngus-fadeIn, svelte-1pzngus-fadeOut;animation-duration:0.2s, 1s;animation-delay:0s, 2s;animation-fill-mode:forwards;position:fixed;z-index:9999 !important}",
  map: null
};
const Toast = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $toastStore, $$unsubscribe_toastStore;
  $$unsubscribe_toastStore = subscribe(toastStore, (value) => $toastStore = value);
  $$result.css.add(css$2);
  $$unsubscribe_toastStore();
  return `${$toastStore.visible ? `<div class="${escape(null_to_empty(`fixed inset-x-0 bottom-0 text-white text-center py-2 toast-panel-${$toastStore.type}`), true) + " svelte-1pzngus"}">${escape($toastStore.message)}</div>` : ``}`;
});
const LoadingIcon_svelte_svelte_type_style_lang = "";
const css$1 = {
  code: "@keyframes svelte-1ormd53-pulse{0%,100%{fill:#ffffff}50%{fill:#2ce3a6}}@keyframes svelte-1ormd53-pulse-text{0%,100%{color:#ffffff}50%{color:#2ce3a6}}.pulse-color.svelte-1ormd53{animation:svelte-1ormd53-pulse 2s infinite}.pulse-text-color.svelte-1ormd53{animation:svelte-1ormd53-pulse-text 2s infinite}",
  map: null
};
const LoadingIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $loadingText, $$unsubscribe_loadingText;
  $$unsubscribe_loadingText = subscribe(loadingText, (value) => $loadingText = value);
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  $$result.css.add(css$1);
  $$unsubscribe_loadingText();
  return `<div class="flex justify-center items-center h-screen"><div class="${escape(null_to_empty(`${className} flex flex-col justify-center items-center h-screen pulse-text-color`), true) + " svelte-1ormd53"}"><div class="relative"><svg xmlns="http://www.w3.org/2000/svg" class="${escape(null_to_empty(`pulse-color w-20 h-20 mb-2 ${className}`), true) + " svelte-1ormd53"}" fill="currentColor" viewBox="0 0 137 188"><path d="M68.8457 0C43.0009 4.21054 19.8233 14.9859 0.331561 30.5217L0.264282 30.6627V129.685L68.7784 187.97L136.528 129.685L136.543 30.6204C117.335 15.7049 94.1282 4.14474 68.8457 0ZM82.388 145.014C82.388 145.503 82.0804 145.992 81.5806 146.114L68.7784 150.329C68.5285 150.39 68.2786 150.39 68.0287 150.329L55.2265 146.114C54.7267 145.931 54.4143 145.503 54.4143 145.014V140.738C54.4143 140.31 54.6642 139.883 55.039 139.7L67.8413 133.102C68.2161 132.919 68.591 132.919 68.9658 133.102L81.768 139.7C82.1429 139.883 82.388 140.31 82.388 140.738V145.014ZM106.464 97.9137C106.464 98.3414 106.214 98.769 105.777 98.9523L96.6607 103.534C96.036 103.84 95.8486 104.573 96.1609 105.122L105.027 121.189C105.277 121.678 105.215 122.228 104.84 122.594L89.7262 137.134C89.2889 137.561 88.6641 137.561 88.1644 137.256L70.9313 125.099C70.369 124.671 70.2441 123.877 70.7439 123.327L84.4208 108.421C85.2329 107.505 84.2958 106.161 83.1713 106.527L68.7447 111.109C68.4948 111.17 68.2449 111.17 67.9951 111.109L53.6358 106.527C52.4488 106.161 51.5742 107.566 52.3863 108.421L66.0584 123.327C66.5582 123.877 66.4332 124.671 65.871 125.099L48.6379 137.256C48.1381 137.561 47.5134 137.561 47.0761 137.134L31.9671 122.533C31.5923 122.167 31.5298 121.617 31.7797 121.128L40.6461 105.061C40.9585 104.45 40.7086 103.778 40.1463 103.473L31.03 98.8912C30.6552 98.7079 30.3428 98.2803 30.3428 97.8526V65.8413C30.3428 64.9249 31.4049 64.314 32.217 64.8639L39.709 69.8122C40.0214 70.0565 40.2088 70.362 40.2088 70.7896L40.2713 79.0368C40.2713 79.4034 40.4587 79.7699 40.7711 80.0143L51.7616 87.5284C52.5737 88.0782 53.6983 87.4673 53.6358 86.4898L52.9486 71.9503C52.9486 71.5838 52.7612 71.2173 52.4488 71.034L30.8426 56.5556C30.5302 56.3112 30.3428 55.9447 30.3428 55.5781V48.4305C30.3428 48.1862 30.4053 47.8807 30.5927 47.6975L38.3971 38.0452C38.7094 37.6176 39.2717 37.4954 39.7715 37.6786L67.9326 47.8807C68.1825 48.0029 68.4948 48.0029 68.7447 47.8807L96.9106 37.6786C97.4104 37.4954 97.9679 37.6786 98.2802 38.0452L106.089 47.6975C106.277 47.8807 106.339 48.1862 106.339 48.4305V55.5781C106.339 55.9447 106.152 56.3112 105.84 56.5556L84.2333 71.034C84.0459 71.2783 83.8585 71.6449 83.8585 72.0114L83.1713 86.5509C83.1088 87.5284 84.2333 88.1393 85.0455 87.5895L96.036 80.0753C96.3484 79.831 96.5358 79.5255 96.5358 79.0979L96.5983 70.8507C96.5983 70.4842 96.7857 70.1176 97.098 69.8733L104.59 64.9249C105.402 64.3751 106.464 64.9249 106.464 65.9024V97.9137Z"></path></svg></div>
    ${escape($loadingText)}</div>
</div>`;
});
const app = "";
const Layout_svelte_svelte_type_style_lang = "";
const css = {
  code: ".loading-overlay.svelte-1ynyyny{position:absolute;top:0;left:0;width:100%;height:100%;display:flex;justify-content:center;align-items:center;background-color:rgba(0, 0, 0, 0.5);z-index:10}main.svelte-1ynyyny{flex:1;display:flex;flex-direction:column}",
  map: null
};
const Layout = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $isLoading, $$unsubscribe_isLoading;
  $$unsubscribe_isLoading = subscribe(isLoading, (value) => $isLoading = value);
  $$result.css.add(css);
  $$unsubscribe_isLoading();
  return `<div class="flex flex-col h-screen justify-between">${validate_component(Header, "Header").$$render($$result, {}, {}, {})}
  ${$isLoading ? `<div class="loading-overlay svelte-1ynyyny">${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}</div>` : `<main class="svelte-1ynyyny">${slots.default ? slots.default({}) : ``}</main>
    ${validate_component(Toast, "Toast").$$render($$result, {}, {}, {})}`}
  ${validate_component(Footer, "Footer").$$render($$result, {}, {}, {})}
</div>`;
});
export {
  ActorFactory as A,
  Layout as L,
  LoadingIcon as a,
  authStore as b,
  getAvailableFormations as g,
  idlFactory$1 as i,
  loadingText as l,
  systemStore as s,
  toastStore as t,
  updateTableData as u
};
