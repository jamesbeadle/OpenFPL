import { c as create_ssr_component, e as escape, n as null_to_empty, d as add_attribute, a as subscribe, o as onDestroy, v as validate_component, m as missing_component, i as each, j as is_promise, g as noop } from "./ssr.js";
import { AuthClient } from "@dfinity/auth-client";
import { nonNullish, isNullish } from "@dfinity/utils";
import { w as writable, r as readable, d as derived } from "./index.js";
import "dompurify";
import { p as page } from "./stores.js";
import { HttpAgent, Actor } from "@dfinity/agent";
const localIdentityCanisterId = {}.VITE_INTERNET_IDENTITY_CANISTER_ID;
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
    signIn: ({ domain }) => (
      // eslint-disable-next-line no-async-promise-executor
      new Promise(async (resolve, reject) => {
        authClient = authClient ?? await createAuthClient();
        const identityProvider = nonNullish(localIdentityCanisterId) ? `http://localhost:4943?canisterId=${localIdentityCanisterId}` : `https://identity.${domain ?? "ic0.app"}`;
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
          windowOpenerFeatures: popupCenter({
            width: AUTH_POPUP_WIDTH,
            height: AUTH_POPUP_HEIGHT
          })
        });
      })
    ),
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
const DEFAULT_ICON_SIZE = 20;
const core = {
  close: "Close",
  back: "Back",
  menu: "Open menu to access navigation options",
  collapse: "Collapse",
  expand: "Expand",
  copy: "Copy to clipboard"
};
const theme = {
  switch_theme: "Switch theme"
};
const progress = {
  completed: "Completed",
  in_progress: "In progress"
};
const en = {
  core,
  theme,
  progress
};
const i18n = readable({
  lang: "en",
  ...en
});
const Back_svelte_svelte_type_style_lang = "";
const Backdrop_svelte_svelte_type_style_lang = "";
const layoutBottomOffset = writable(0);
const BottomSheet_svelte_svelte_type_style_lang = "";
const initBusyStore$1 = () => {
  const DEFAULT_STATE = [];
  const { subscribe: subscribe2, update, set } = writable(DEFAULT_STATE);
  return {
    subscribe: subscribe2,
    /**
     * Show the busy-screen if not visible
     */
    startBusy({ initiator: newInitiator, text }) {
      update((state) => [
        ...state.filter(({ initiator }) => newInitiator !== initiator),
        { initiator: newInitiator, text }
      ]);
    },
    /**
     * Hide the busy-screen if no other initiators are done
     */
    stopBusy(initiatorToRemove) {
      update((state) => state.filter(({ initiator }) => initiator !== initiatorToRemove));
    },
    resetForTesting() {
      set(DEFAULT_STATE);
    }
  };
};
const busyStore = initBusyStore$1();
derived(busyStore, ($busyStore) => $busyStore.length > 0);
derived(busyStore, ($busyStore) => $busyStore.reverse().find(({ text }) => nonNullish(text))?.text);
const Spinner_svelte_svelte_type_style_lang = "";
const css$6 = {
  code: ".medium.svelte-85668t{--spinner-size:30px}.small.svelte-85668t{--spinner-size:calc(var(--line-height-standard) * 1rem)}.tiny.svelte-85668t{--spinner-size:calc(var(--line-height-standard) * 0.5rem)}svg.svelte-85668t{width:var(--spinner-size);height:var(--spinner-size);animation:spinner-linear-rotate 2000ms linear infinite;position:absolute;top:calc(50% - var(--spinner-size) / 2);left:calc(50% - var(--spinner-size) / 2);--radius:45px;--circumference:calc(3.1415926536 * var(--radius) * 2);--start:calc((1 - 0.05) * var(--circumference));--end:calc((1 - 0.8) * var(--circumference))}svg.inline.svelte-85668t{display:inline-block;position:relative}circle.svelte-85668t{stroke-dasharray:var(--circumference);stroke-width:10%;transform-origin:50% 50% 0;transition-property:stroke;animation-name:spinner-stroke-rotate-100;animation-duration:4000ms;animation-timing-function:cubic-bezier(0.35, 0, 0.25, 1);animation-iteration-count:infinite;fill:transparent;stroke:currentColor;transition:stroke-dashoffset 225ms linear}@keyframes spinner-linear-rotate{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}@keyframes spinner-stroke-rotate-100{0%{stroke-dashoffset:var(--start);transform:rotate(0)}12.5%{stroke-dashoffset:var(--end);transform:rotate(0)}12.5001%{stroke-dashoffset:var(--end);transform:rotateX(180deg) rotate(72.5deg)}25%{stroke-dashoffset:var(--start);transform:rotateX(180deg) rotate(72.5deg)}25.0001%{stroke-dashoffset:var(--start);transform:rotate(270deg)}37.5%{stroke-dashoffset:var(--end);transform:rotate(270deg)}37.5001%{stroke-dashoffset:var(--end);transform:rotateX(180deg) rotate(161.5deg)}50%{stroke-dashoffset:var(--start);transform:rotateX(180deg) rotate(161.5deg)}50.0001%{stroke-dashoffset:var(--start);transform:rotate(180deg)}62.5%{stroke-dashoffset:var(--end);transform:rotate(180deg)}62.5001%{stroke-dashoffset:var(--end);transform:rotateX(180deg) rotate(251.5deg)}75%{stroke-dashoffset:var(--start);transform:rotateX(180deg) rotate(251.5deg)}75.0001%{stroke-dashoffset:var(--start);transform:rotate(90deg)}87.5%{stroke-dashoffset:var(--end);transform:rotate(90deg)}87.5001%{stroke-dashoffset:var(--end);transform:rotateX(180deg) rotate(341.5deg)}100%{stroke-dashoffset:var(--start);transform:rotateX(180deg) rotate(341.5deg)}}",
  map: null
};
const Spinner = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { inline = false } = $$props;
  let { size = "medium" } = $$props;
  if ($$props.inline === void 0 && $$bindings.inline && inline !== void 0)
    $$bindings.inline(inline);
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  $$result.css.add(css$6);
  return `  <svg class="${[escape(null_to_empty(size), true) + " svelte-85668t", inline ? "inline" : ""].join(" ").trim()}" preserveAspectRatio="xMidYMid meet" focusable="false" aria-hidden="true" data-tid="spinner" viewBox="0 0 100 100"><circle cx="50%" cy="50%" r="45" class="svelte-85668t"></circle></svg>`;
});
const BusyScreen_svelte_svelte_type_style_lang = "";
const IconCheckCircle = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `24px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg${add_attribute("width", size, 0)}${add_attribute("height", size, 0)} viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="1.25" y="1.25" width="21.5" height="21.5" rx="10.75" fill="var(--icon-check-circle-background, transparent)"></rect><path d="M7 11L11 15L17 9" stroke="var(--icon-check-circle-color, currentColor)" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><rect x="1.25" y="1.25" width="21.5" height="21.5" rx="10.75" stroke="var(--icon-check-circle-background, currentColor)" stroke-width="1.5"></rect></svg>`;
});
const Card_svelte_svelte_type_style_lang = "";
const Checkbox_svelte_svelte_type_style_lang = "";
const TestIdWrapper_svelte_svelte_type_style_lang = "";
const Collapsible_svelte_svelte_type_style_lang = "";
const Toolbar_svelte_svelte_type_style_lang = "";
const IconClose = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg${add_attribute("height", size, 0)}${add_attribute("width", size, 0)} viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="14.4194" y="4.52441" width="1.5" height="14" rx="0.75" transform="rotate(45 14.4194 4.52441)" fill="currentColor"></rect><rect x="4.5199" y="5.58496" width="1.5" height="14" rx="0.75" transform="rotate(-45 4.5199 5.58496)" fill="currentColor"></rect></svg>`;
});
const MenuButton_svelte_svelte_type_style_lang = "";
const Header_svelte_svelte_type_style_lang$1 = "";
const Content_svelte_svelte_type_style_lang = "";
const IconError = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg xmlns="http://www.w3.org/2000/svg"${add_attribute("height", size, 0)} viewBox="0 0 24 24"${add_attribute("width", size, 0)} fill="currentColor"><path d="M0 0h24v24H0z" fill="none"></path><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"></path></svg>`;
});
const IconInfo_svelte_svelte_type_style_lang = "";
const css$5 = {
  code: "svg.svelte-1lui9gh{vertical-align:middle}",
  map: null
};
const IconInfo = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  $$result.css.add(css$5);
  return `  <svg${add_attribute("width", size, 0)}${add_attribute("height", size, 0)} viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" data-tid="icon-info" class="svelte-1lui9gh"><path d="M10.2222 17.5C14.3643 17.5 17.7222 14.1421 17.7222 10C17.7222 5.85786 14.3643 2.5 10.2222 2.5C6.08003 2.5 2.72217 5.85786 2.72217 10C2.72217 14.1421 6.08003 17.5 10.2222 17.5Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M10.2222 13.3333V10" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M10.2222 6.66699H10.2305" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></svg>`;
});
const IconMeter_svelte_svelte_type_style_lang = "";
const IconSync_svelte_svelte_type_style_lang = "";
const IconWarning = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { size = `${DEFAULT_ICON_SIZE}px` } = $$props;
  if ($$props.size === void 0 && $$bindings.size && size !== void 0)
    $$bindings.size(size);
  return `  <svg xmlns="http://www.w3.org/2000/svg"${add_attribute("height", size, 0)} viewBox="0 0 24 24"${add_attribute("width", size, 0)} fill="currentColor"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"></path></svg>`;
});
const Copy_svelte_svelte_type_style_lang = "";
const Dropdown_svelte_svelte_type_style_lang = "";
const ExternalLink_svelte_svelte_type_style_lang = "";
const HeaderTitle_svelte_svelte_type_style_lang = "";
const InfiniteScroll_svelte_svelte_type_style_lang = "";
const Input_svelte_svelte_type_style_lang = "";
const InputRange_svelte_svelte_type_style_lang = "";
const Island_svelte_svelte_type_style_lang = "";
const ItemAction_svelte_svelte_type_style_lang = "";
const KeyValuePair_svelte_svelte_type_style_lang = "";
const KeyValuePairInfo_svelte_svelte_type_style_lang = "";
const SplitPane_svelte_svelte_type_style_lang = "";
var Theme;
(function(Theme2) {
  Theme2["DARK"] = "dark";
  Theme2["LIGHT"] = "light";
})(Theme || (Theme = {}));
const isNode = () => typeof process !== "undefined" && process.versions != null && process.versions.node != null;
const enumFromStringExists = ({ obj, value }) => Object.values(obj).includes(value);
const THEME_ATTRIBUTE = "theme";
const LOCALSTORAGE_THEME_KEY = "nnsTheme";
const initTheme = () => {
  if (isNode()) {
    return void 0;
  }
  const theme2 = document.documentElement.getAttribute(THEME_ATTRIBUTE);
  const initialTheme = enumFromStringExists({
    obj: Theme,
    value: theme2
  }) ? theme2 : Theme.DARK;
  applyTheme({ theme: initialTheme, preserve: false });
  return initialTheme;
};
const applyTheme = ({ theme: theme2, preserve = true }) => {
  const { documentElement, head } = document;
  documentElement.setAttribute(THEME_ATTRIBUTE, theme2);
  const color = getComputedStyle(documentElement).getPropertyValue("--theme-color");
  head?.children?.namedItem("theme-color")?.setAttribute("content", color.trim());
  if (preserve) {
    localStorage.setItem(LOCALSTORAGE_THEME_KEY, JSON.stringify(theme2));
  }
};
initTheme();
const MenuBackground_svelte_svelte_type_style_lang = "";
var Menu;
(function(Menu2) {
  Menu2["COLLAPSED"] = "collapsed";
  Menu2["EXPANDED"] = "expanded";
})(Menu || (Menu = {}));
const MENU_ATTRIBUTE = "menu";
const LOCALSTORAGE_MENU_KEY = "nnsMenu";
const initMenu = () => {
  if (isNode()) {
    return void 0;
  }
  const menu = document.documentElement.getAttribute(MENU_ATTRIBUTE);
  const initialMenu2 = enumFromStringExists({
    obj: Menu,
    value: menu
  }) ? menu : Menu.EXPANDED;
  applyMenu({ menu: initialMenu2, preserve: false });
  return initialMenu2;
};
const applyMenu = ({ menu, preserve = true }) => {
  const { documentElement } = document;
  documentElement.setAttribute(MENU_ATTRIBUTE, menu);
  if (preserve) {
    localStorage.setItem(LOCALSTORAGE_MENU_KEY, JSON.stringify(menu));
  }
};
const initialMenu = initMenu();
const initMenuStore = () => {
  const { subscribe: subscribe2, update } = writable(initialMenu);
  return {
    subscribe: subscribe2,
    toggle: () => {
      update((state) => {
        const menu = state === Menu.EXPANDED ? Menu.COLLAPSED : Menu.EXPANDED;
        applyMenu({ menu, preserve: true });
        return menu;
      });
    }
  };
};
const menuStore = initMenuStore();
derived(menuStore, ($menuStore) => $menuStore === Menu.COLLAPSED);
const Menu_svelte_svelte_type_style_lang = "";
const StretchPane_svelte_svelte_type_style_lang = "";
const MenuItem_svelte_svelte_type_style_lang = "";
const Modal_svelte_svelte_type_style_lang = "";
const Nav_svelte_svelte_type_style_lang = "";
const PageBanner_svelte_svelte_type_style_lang = "";
const Popover_svelte_svelte_type_style_lang = "";
const ProgressBar_svelte_svelte_type_style_lang = "";
const ProgressSteps_svelte_svelte_type_style_lang = "";
const QRCode_svelte_svelte_type_style_lang = "";
const QRCodeReader_svelte_svelte_type_style_lang = "";
const QRCodeReaderModal_svelte_svelte_type_style_lang = "";
const Section_svelte_svelte_type_style_lang = "";
const Segment_svelte_svelte_type_style_lang = "";
const SegmentButton_svelte_svelte_type_style_lang = "";
const SkeletonText_svelte_svelte_type_style_lang = "";
const SplitBlock_svelte_svelte_type_style_lang = "";
const SplitContent_svelte_svelte_type_style_lang = "";
const Tag_svelte_svelte_type_style_lang = "";
const Toggle_svelte_svelte_type_style_lang = "";
const ThemeToggle_svelte_svelte_type_style_lang = "";
const initToastsStore = () => {
  const { subscribe: subscribe2, update, set } = writable([]);
  return {
    subscribe: subscribe2,
    show({ id, ...rest }) {
      const toastId = id ?? Symbol("toast");
      update((messages) => {
        return [...messages, { ...rest, id: toastId }];
      });
      return toastId;
    },
    hide(idToHide) {
      update((messages) => messages.filter(({ id }) => id !== idToHide));
    },
    update({ id, content }) {
      update((messages) => (
        // use map to preserve order
        messages.map((message) => {
          if (message.id !== id) {
            return message;
          }
          return {
            ...message,
            ...content
          };
        })
      ));
    },
    reset(levels) {
      if (nonNullish(levels) && levels.length > 0) {
        update((messages) => messages.filter(({ level }) => !levels.includes(level)));
        return;
      }
      set([]);
    }
  };
};
const toastsStore = initToastsStore();
const Toast_svelte_svelte_type_style_lang = "";
const css$4 = {
  code: ".toast.svelte-1ih7d9r.svelte-1ih7d9r{display:flex;justify-content:space-between;align-items:center;gap:var(--padding-1_5x);background:var(--overlay-background);color:var(--overlay-background-contrast);--button-secondary-background:var(--focus-background);border-radius:var(--border-radius);box-shadow:var(--strong-shadow, 8px 8px 16px 0 rgba(0, 0, 0, 0.25));padding:var(--padding-1_5x);box-sizing:border-box}.toast.inverted.svelte-1ih7d9r.svelte-1ih7d9r{background:var(--toast-inverted-background);color:var(--toast-inverted-background-contrast)}.toast.svelte-1ih7d9r .icon.svelte-1ih7d9r{line-height:0}.toast.svelte-1ih7d9r .icon.success.svelte-1ih7d9r{color:var(--positive-emphasis)}.toast.svelte-1ih7d9r .icon.info.svelte-1ih7d9r{color:var(--primary)}.toast.svelte-1ih7d9r .icon.warn.svelte-1ih7d9r{color:var(--warning-emphasis-shade)}.toast.svelte-1ih7d9r .icon.error.svelte-1ih7d9r{color:var(--negative-emphasis)}.toast.svelte-1ih7d9r .msg.svelte-1ih7d9r{flex-grow:1;margin:0;word-break:break-word}.toast.svelte-1ih7d9r .msg.scroll.svelte-1ih7d9r{max-height:calc(8.5 * var(--padding));overflow-y:auto}.toast.svelte-1ih7d9r .msg.truncate.svelte-1ih7d9r{white-space:var(--text-white-space, nowrap);overflow:hidden;text-overflow:ellipsis}.toast.svelte-1ih7d9r .msg.truncate .title.svelte-1ih7d9r{white-space:var(--text-white-space, nowrap);overflow:hidden;text-overflow:ellipsis}.toast.svelte-1ih7d9r .msg.clamp.svelte-1ih7d9r{display:-webkit-box;-webkit-box-orient:vertical;-webkit-line-clamp:3;overflow:hidden}.toast.svelte-1ih7d9r .msg.clamp .title.svelte-1ih7d9r{display:-webkit-box;-webkit-box-orient:vertical;-webkit-line-clamp:2;overflow:hidden}.toast.svelte-1ih7d9r .title.svelte-1ih7d9r{display:block;font-size:var(--font-size-h4);line-height:var(--line-height-h4);font-weight:var(--font-weight-bold)}.toast.svelte-1ih7d9r button.close.svelte-1ih7d9r{padding:0;line-height:0;color:inherit}",
  map: null
};
const Toast = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $i18n, $$unsubscribe_i18n;
  $$unsubscribe_i18n = subscribe(i18n, (value) => $i18n = value);
  let { msg } = $$props;
  const iconMapper = (level2) => ({
    ["success"]: IconCheckCircle,
    ["warn"]: IconWarning,
    ["error"]: IconError,
    ["info"]: IconInfo,
    ["custom"]: void 0
  })[level2];
  let text;
  let level;
  let spinner;
  let title;
  let overflow;
  let position;
  let icon;
  let theme2;
  let scroll;
  let truncate;
  let clamp;
  let timeoutId = void 0;
  const cleanUpAutoHide = () => {
    if (isNullish(timeoutId)) {
      return;
    }
    clearTimeout(timeoutId);
  };
  const minHeightMessage = `min-height: ${DEFAULT_ICON_SIZE}px;`;
  onDestroy(cleanUpAutoHide);
  if ($$props.msg === void 0 && $$bindings.msg && msg !== void 0)
    $$bindings.msg(msg);
  $$result.css.add(css$4);
  ({ text, level, spinner, title, overflow, position, icon, theme: theme2 } = msg);
  scroll = overflow === void 0 || overflow === "scroll";
  truncate = overflow === "truncate";
  clamp = overflow === "clamp";
  $$unsubscribe_i18n();
  return `<div role="dialog" class="${escape(null_to_empty(`toast ${theme2 ?? "themed"}`), true) + " svelte-1ih7d9r"}"><div class="${"icon " + escape(level, true) + " svelte-1ih7d9r"}" aria-hidden="true">${spinner ? `${validate_component(Spinner, "Spinner").$$render($$result, { size: "small", inline: true }, {}, {})}` : `${nonNullish(icon) ? `${validate_component(icon || missing_component, "svelte:component").$$render($$result, {}, {}, {})}` : `${iconMapper(level) ? `${validate_component(iconMapper(level) || missing_component, "svelte:component").$$render($$result, { size: DEFAULT_ICON_SIZE }, {}, {})}` : ``}`}`}</div> <p class="${[
    "msg svelte-1ih7d9r",
    (truncate ? "truncate" : "") + " " + (clamp ? "clamp" : "") + " " + (scroll ? "scroll" : "")
  ].join(" ").trim()}"${add_attribute("style", minHeightMessage, 0)}>${nonNullish(title) ? `<span class="title svelte-1ih7d9r">${escape(title)}</span>` : ``} ${escape(text)}</p> <button class="close svelte-1ih7d9r"${add_attribute("aria-label", $i18n.core.close, 0)}>${validate_component(IconClose, "IconClose").$$render($$result, {}, {}, {})}</button> </div>`;
});
const Toasts_svelte_svelte_type_style_lang = "";
const css$3 = {
  code: ".wrapper.svelte-24m335{position:fixed;left:50%;transform:translate(-50%, 0);bottom:calc(var(--layout-bottom-offset, 0) + var(--padding-2x));width:calc(100% - var(--padding-8x) - var(--padding-0_5x));display:flex;flex-direction:column;gap:var(--padding);z-index:var(--toast-info-z-index)}.wrapper.error.svelte-24m335{z-index:var(--toast-error-z-index)}@media(min-width: 1024px){.wrapper.svelte-24m335{max-width:calc(var(--section-max-width) - var(--padding-2x))}}.top.svelte-24m335{top:calc(var(--header-height) + var(--padding-3x));bottom:unset;width:calc(100% - var(--padding-6x))}@media(min-width: 1024px){.top.svelte-24m335{right:var(--padding-2x);left:unset;transform:none;max-width:calc(var(--section-max-width) / 1.5 - var(--padding-2x))}}",
  map: null
};
const Toasts = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $toastsStore, $$unsubscribe_toastsStore;
  let $layoutBottomOffset, $$unsubscribe_layoutBottomOffset;
  $$unsubscribe_toastsStore = subscribe(toastsStore, (value) => $toastsStore = value);
  $$unsubscribe_layoutBottomOffset = subscribe(layoutBottomOffset, (value) => $layoutBottomOffset = value);
  let { position = "bottom" } = $$props;
  let toasts = [];
  let hasErrors;
  if ($$props.position === void 0 && $$bindings.position && position !== void 0)
    $$bindings.position(position);
  $$result.css.add(css$3);
  toasts = $toastsStore.filter(({ position: pos }) => (pos ?? "bottom") === position);
  hasErrors = toasts.find(({ level }) => ["error", "warn"].includes(level)) !== void 0;
  $$unsubscribe_toastsStore();
  $$unsubscribe_layoutBottomOffset();
  return `${toasts.length > 0 ? `<div class="${[
    escape(null_to_empty(`wrapper ${position}`), true) + " svelte-24m335",
    hasErrors ? "error" : ""
  ].join(" ").trim()}"${add_attribute("style", `--layout-bottom-offset: ${$layoutBottomOffset}px`, 0)}>${each(toasts, (msg) => {
    return `${validate_component(Toast, "Toast").$$render($$result, { msg }, {}, {})}`;
  })}</div>` : ``}`;
});
const WizardTransition_svelte_svelte_type_style_lang = "";
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
const authSignedInStore = derived(
  authStore,
  ({ identity }) => identity !== null && identity !== void 0
);
const Header_svelte_svelte_type_style_lang = "";
const css$2 = {
  code: 'header.svelte-197nckd{background-color:rgba(36, 37, 41, 0.9)}.nav-underline.svelte-197nckd{position:relative;display:inline-block;color:white}.nav-underline.svelte-197nckd::after{content:"";position:absolute;width:100%;height:2px;background-color:#2ce3a6;bottom:0;left:0;transform:scaleX(0);transition:transform 0.3s ease-in-out;color:#2ce3a6}.nav-underline.svelte-197nckd:hover::after,.nav-underline.active.svelte-197nckd::after{transform:scaleX(1);color:#2ce3a6}.nav-underline.svelte-197nckd:hover::after{transform:scaleX(1);background-color:gray}.nav-button.svelte-197nckd{background-color:transparent}.nav-button.svelte-197nckd:hover{background-color:transparent;color:#2ce3a6;border:none}',
  map: null
};
const Header = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let profileSrc;
  let currentClass;
  let $page, $$unsubscribe_page;
  let $profile, $$unsubscribe_profile;
  let $authSignedInStore, $$unsubscribe_authSignedInStore;
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  $$unsubscribe_authSignedInStore = subscribe(authSignedInStore, (value) => $authSignedInStore = value);
  let profile = writable(null);
  $$unsubscribe_profile = subscribe(profile, (value) => $profile = value);
  let showProfileDropdown = false;
  onDestroy(() => {
    if (typeof window !== "undefined") {
      document.removeEventListener("click", closeDropdownOnClickOutside);
    }
  });
  function closeDropdownOnClickOutside(event) {
    const target = event.target;
    if (target instanceof Element) {
      if (!target.closest(".profile-dropdown") && !target.closest(".profile-pic")) {
        showProfileDropdown = false;
      }
    }
  }
  $$result.css.add(css$2);
  profileSrc = URL.createObjectURL(new Blob([new Uint8Array($profile?.profilePicture ?? [])]));
  currentClass = (route) => $page.url.pathname === route ? "text-blue-500 nav-underline active" : "nav-underline";
  $$unsubscribe_page();
  $$unsubscribe_profile();
  $$unsubscribe_authSignedInStore();
  return `<header class="svelte-197nckd"><nav class="text-white"><div class="px-4 h-16 flex justify-between items-center w-full"><a href="/" class="hover:text-gray-400 flex items-center">${validate_component(OpenFPLIcon, "OpenFPLIcon").$$render($$result, { className: "h-8 w-auto" }, {}, {})}<b class="ml-2" data-svelte-h="svelte-6ko9z9">OpenFPL</b></a> <button class="md:hidden focus:outline-none" data-svelte-h="svelte-10fl43a"><svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="24" height="2" rx="1" fill="currentColor"></rect><rect y="8" width="24" height="2" rx="1" fill="currentColor"></rect><rect y="16" width="24" height="2" rx="1" fill="currentColor"></rect></svg></button> ${$authSignedInStore ? `<ul class="hidden md:flex text-base md:text-xs lg:text-base"><li class="mx-2 flex items-center h-16"><a href="/" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/"), true) + " svelte-197nckd"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-fx32ra">Home</span></a></li> <li class="mx-2 flex items-center h-16"><a href="/pick-team" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/pick-team"), true) + " svelte-197nckd"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-1k6m4hl">Squad Selection</span></a></li> <li class="mx-2 flex items-center h-16"><a href="/governance" class="${"flex items-center h-full nav-underline hover:text-gray-400 $" + escape(currentClass("/governance"), true) + " svelte-197nckd"}"><span class="flex items-center h-full px-4" data-svelte-h="svelte-qfd2bh">Governance</span></a></li> ${``} <li class="p-2 flex flex-1 items-center"><div class="relative inline-block"><button><img${add_attribute("src", profileSrc, 0)} alt="Profile" class="w-12 h-12 rounded-sm profile-pic" aria-label="Toggle Profile"></button> <div class="${escape(null_to_empty(`absolute right-0 top-full w-48 bg-black rounded-b-md rounded-l-md shadow-lg z-50 profile-dropdown ${showProfileDropdown ? "block" : "hidden"}`), true) + " svelte-197nckd"}"><ul class="text-gray-700"><li><a href="/profile" class="flex items-center h-full w-full nav-underline hover:text-gray-400 svelte-197nckd"><span class="flex items-center h-full w-full"><img${add_attribute("src", profileSrc, 0)} alt="logo" class="w-8 h-8 my-2 ml-4 mr-2"> <p class="w-full min-w-[125px] max-w-[125px] truncate">${escape($profile?.displayName != $profile?.principalId ? $profile?.displayName : "Profile")}</p></span></a></li> <li><button class="flex items-center justify-center px-4 pb-2 pt-1 text-white rounded-md shadow focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-197nckd">Disconnect
                      ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div></div></li></ul> <div class="${escape(null_to_empty(`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-197nckd"}"><ul class="flex flex-col"><li class="p-2"><a href="/" class="${escape(null_to_empty(`nav-underline hover:text-gray-400 ${currentClass("/")}`), true) + " svelte-197nckd"}">Home</a></li> <li class="p-2"><a href="/pick-team" class="${escape(null_to_empty(currentClass("/pick-team")), true) + " svelte-197nckd"}">Squad Selection</a></li> <li class="p-2"><a href="/governance" class="${escape(null_to_empty(currentClass("/governance")), true) + " svelte-197nckd"}">Governance</a></li> <li class="p-2"><a href="/profile" class="${"flex h-full w-full nav-underline hover:text-gray-400 w-full $" + escape(currentClass("/profile"), true) + " svelte-197nckd"}"><span class="flex items-center h-full w-full"><img${add_attribute("src", profileSrc, 0)} alt="logo" class="w-8 h-8 rounded-sm"> <p class="w-full min-w-[100px] max-w-[100px] truncate p-2">${escape($profile?.displayName != $profile?.principalId ? $profile?.displayName : "Profile")}</p></span></a></li></ul></div>` : `<ul class="hidden md:flex"><li class="mx-2 flex items-center h-16"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-197nckd">Connect
              ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul> <div class="${escape(null_to_empty(`absolute top-12 right-2.5 bg-black rounded-lg shadow-md z-10 p-2 ${"hidden"} md:hidden`), true) + " svelte-197nckd"}"><ul class="flex flex-col"><li class="p-2"><button class="flex items-center justify-center px-4 py-2 bg-blue-500 text-white rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-300 focus:ring-opacity-50 nav-button svelte-197nckd">Connect
                ${validate_component(WalletIcon, "WalletIcon").$$render($$result, { className: "ml-2 h-6 w-6 mt-1" }, {}, {})}</button></li></ul></div>`}</div></nav> </header>`;
});
const JunoIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 130 130"><g id="Layer_1-2"><g><path d="M91.99,64.798c0,-20.748 -16.845,-37.593 -37.593,-37.593l-0.003,-0c-20.749,-0 -37.594,16.845 -37.594,37.593l0,0.004c0,20.748 16.845,37.593 37.594,37.593l0.003,0c20.748,0 37.593,-16.845 37.593,-37.593l0,-0.004Z"></path><circle cx="87.153" cy="50.452" r="23.247" style="fill:#7888ff;"></circle></g></g></svg>`;
});
const Footer = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<footer class="bg-gray-900 text-white py-3"><div class="container mx-auto flex flex-col sm:flex-row items-start sm:items-center justify-between text-xs"><div class="flex-1" data-svelte-h="svelte-1x4c2nc"><div class="flex justify-start"><div class="flex flex-row pl-4"><a href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/?ref=zv6hh-xaaaa-aaaar-ac35q-cai" target="_blank" rel="noopener noreferrer"><img src="openchat.png" class="h-4 w-auto mb-2 mr-2" alt="OpenChat"></a> <a href="https://twitter.com/OpenFPL_DAO" target="_blank" rel="noopener noreferrer"><img src="twitter.png" class="h-4 w-auto mb-2 mr-2" alt="Twitter"></a> <a href="https://t.co/WmOhFA8JUR" target="_blank" rel="noopener noreferrer"><img src="discord.png" class="h-4 w-auto mb-2 mr-2" alt="Discord"></a> <a href="https://t.co/vVkquMrdOu" target="_blank" rel="noopener noreferrer"><img src="telegram.png" class="h-4 w-auto mb-2 mr-2" alt="Telegram"></a> <a href="https://github.com/jamesbeadle/OpenFPL" target="_blank" rel="noopener noreferrer"><img src="github.png" class="h-4 w-auto mb-2" alt="GitHub"></a></div></div> <div class="flex justify-start"><div class="flex flex-col sm:flex-row sm:space-x-2 pl-4"><a href="/whitepaper" class="hover:text-gray-300">Whitepaper</a> <span class="hidden sm:flex">|</span> <a href="/gameplay-rules" class="hover:text-gray-300">Gameplay Rules</a> <span class="hidden sm:flex">|</span> <a href="/terms" class="hover:text-gray-300">Terms &amp; Conditions</a></div></div></div> <div class="flex-0"><a href="/"><b class="px-4 mt-2 sm:mt-0 sm:px-10 flex items-center">${validate_component(OpenFPLIcon, "OpenFplIcon").$$render($$result, { className: "h-6 w-auto mr-2" }, {}, {})}OpenFPL</b></a></div> <div class="flex-1"><div class="flex justify-end"><div class="text-right px-4 sm:px-0 mt-1 sm:mt-0 md:mr-4"><a href="https://juno.build" target="_blank" class="hover:text-gray-300 flex items-center">Sponsored By juno.build
            ${validate_component(JunoIcon, "JunoIcon").$$render($$result, { className: "h-8 w-auto ml-2" }, {}, {})}</a></div></div></div></div></footer>`;
});
const initBusyStore = () => {
  const { subscribe: subscribe2, set } = writable(void 0);
  return {
    subscribe: subscribe2,
    start() {
      set({ spinner: true, close: false });
    },
    show() {
      set({ spinner: true, close: true });
    },
    stop() {
      set(void 0);
    }
  };
};
const busy = initBusyStore();
const Busy_svelte_svelte_type_style_lang = "";
const css$1 = {
  code: ".busy.svelte-19btxid{z-index:calc(var(--z-index) + 1000);position:fixed;top:0;right:0;bottom:0;left:0;background:var(--backdrop)}.content.svelte-19btxid{position:absolute;top:50%;left:50%;transform:translate(-50%, -50%);display:flex;justify-content:center;align-items:center;flex-direction:column;width:-moz-fit-content;width:fit-content;background:transparent}.spinner.svelte-19btxid{position:relative;height:30px;margin:1.45rem}.close.svelte-19btxid{align-self:flex-end}",
  map: null
};
const Busy = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $busy, $$unsubscribe_busy;
  $$unsubscribe_busy = subscribe(busy, (value) => $busy = value);
  $$result.css.add(css$1);
  $$unsubscribe_busy();
  return `${nonNullish($busy) ? `<div class="${["busy svelte-19btxid", $busy.close ? "close" : ""].join(" ").trim()}" role="button" tabindex="-1"><div class="content svelte-19btxid">${$busy.spinner ? `<div class="spinner text-off-white svelte-19btxid">${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}</div>` : ``} ${$busy.close ? `<button aria-label="Close" class="text-off-white" data-svelte-h="svelte-1o9iah3">Cancel</button>` : ``}</div></div>` : ``}`;
});
const app = "";
const Layout_svelte_svelte_type_style_lang = "";
const css = {
  code: "main.svelte-vmfccd{flex:1;display:flex;flex-direction:column}",
  map: null
};
const Layout = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_authStore;
  $$unsubscribe_authStore = subscribe(authStore, (value) => value);
  const init = async () => await Promise.all([syncAuthStore()]);
  const syncAuthStore = async () => {
    {
      return;
    }
  };
  $$result.css.add(css);
  $$unsubscribe_authStore();
  return ` ${function(__value) {
    if (is_promise(__value)) {
      __value.then(null, noop);
      return ` <div>${validate_component(Spinner, "Spinner").$$render($$result, {}, {}, {})}</div> `;
    }
    return function(_) {
      return ` <div class="flex flex-col h-screen justify-between">${validate_component(Header, "Header").$$render($$result, {}, {}, {})} <main class="svelte-vmfccd">${slots.default ? slots.default({}) : ``}</main> ${validate_component(Footer, "Footer").$$render($$result, {}, {}, {})}</div> `;
    }();
  }(init())} ${validate_component(Toasts, "Toasts").$$render($$result, {}, {}, {})} ${validate_component(Busy, "Busy").$$render($$result, {}, {}, {})}`;
});
export {
  ActorFactory as A,
  IconClose as I,
  Layout as L,
  authStore as a,
  idlFactory$1 as b,
  getAvailableFormations as g,
  i18n as i,
  systemStore as s,
  toastsStore as t,
  updateTableData as u
};
