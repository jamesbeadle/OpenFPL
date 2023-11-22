import { A as AUTH_MAX_TIME_TO_LIVE, a as AUTH_POPUP_WIDTH, b as AUTH_POPUP_HEIGHT, O as OpenFPLIcon } from "./Layout.js";
import { AuthClient } from "@dfinity/auth-client";
import "@dfinity/utils";
import { w as writable } from "./index.js";
import { HttpAgent, Actor } from "@dfinity/agent";
import { c as create_ssr_component, e as escape, n as null_to_empty, v as validate_component, b as add_attribute } from "./index2.js";
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
  const { subscribe, set, update } = writable({
    identity: void 0
  });
  return {
    subscribe,
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
const idlFactory = ({ IDL }) => {
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
    weeklyPositionText: IDL.Text,
    gameweeks: IDL.Vec(FantasyTeamSnapshot),
    monthlyPosition: IDL.Int,
    seasonPosition: IDL.Int,
    monthlyPositionText: IDL.Text,
    profilePicture: IDL.Vec(IDL.Nat8),
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
    principalName: IDL.Text,
    profilePicture: IDL.Vec(IDL.Nat8),
    membershipType: IDL.Nat8
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
  return IDL.Service({
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
    getFixture: IDL.Func([SeasonId, GameweekNumber, FixtureId], [Fixture], []),
    getFixtureDTOs: IDL.Func([], [IDL.Vec(FixtureDTO)], ["query"]),
    getFixtures: IDL.Func([], [IDL.Vec(Fixture)], ["query"]),
    getFixturesForSeason: IDL.Func([SeasonId], [IDL.Vec(Fixture)], ["query"]),
    getManager: IDL.Func(
      [IDL.Text, SeasonId, GameweekNumber],
      [ManagerDTO],
      ["query"]
    ),
    getProfileDTO: IDL.Func([], [ProfileDTO], []),
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
    getValidatableFixtures: IDL.Func([], [IDL.Vec(Fixture)], ["query"]),
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
    rescheduleFixture: IDL.Func([], [], []),
    saveFantasyTeam: IDL.Func(
      [IDL.Vec(IDL.Nat16), IDL.Nat16, IDL.Nat8, IDL.Nat16, IDL.Nat16],
      [Result],
      []
    ),
    savePlayerEvents: IDL.Func([FixtureId, IDL.Vec(PlayerEventData)], [], []),
    updateDisplayName: IDL.Func([IDL.Text], [Result], []),
    updateFavouriteTeam: IDL.Func([IDL.Nat16], [Result], []),
    updateProfilePicture: IDL.Func([IDL.Vec(IDL.Nat8)], [Result], []),
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
    return Actor.createActor(idlFactory2, {
      agent,
      canisterId,
      ...options?.actorOptions
    });
  }
}
const LoadingIcon_svelte_svelte_type_style_lang = "";
const css = {
  code: "circle.svelte-1nhsm5j{transition:stroke-dashoffset 0.2s}.svg-scale.svelte-1nhsm5j{transform:scale(2)}",
  map: null
};
const LoadingIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { progress = 0 } = $$props;
  let { className = "" } = $$props;
  if ($$props.progress === void 0 && $$bindings.progress && progress !== void 0)
    $$bindings.progress(progress);
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  $$result.css.add(css);
  return `<div class="flex justify-center items-center h-screen"><div class="${escape(null_to_empty(`${className} flex justify-center items-center h-screen`), true) + " svelte-1nhsm5j"}"><div class="relative">${validate_component(OpenFPLIcon, "OpenFplIcon").$$render($$result, { className: "h-12 w-12" }, {}, {})}

      <svg class="absolute top-0 left-0 h-full w-full svg-scale svelte-1nhsm5j" viewBox="0 0 100 100"><circle cx="50" cy="50" r="45" stroke="#2CE3A6" stroke-dasharray="283"${add_attribute("stroke-dashoffset", 283 - progress / 100 * 283, 0)} fill="transparent" stroke-width="5" transform="rotate(-90 50 50)" class="svelte-1nhsm5j"></circle></svg></div></div>
</div>`;
});
export {
  ActorFactory as A,
  LoadingIcon as L,
  authStore as a,
  idlFactory as i
};
