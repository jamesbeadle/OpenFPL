import { c as create_ssr_component, b as add_attribute, a as subscribe, v as validate_component, e as escape, n as null_to_empty } from "../../chunks/index2.js";
import { w as writable } from "../../chunks/index.js";
import { L as Layout } from "../../chunks/Layout.js";
import { HttpAgent, Actor } from "@dfinity/agent";
const Fixtures = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `<h1>Fixtures</h1>`;
});
const BadgeIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  let { primaryColour = "" } = $$props;
  let { secondaryColour = "" } = $$props;
  let { thirdColour = "" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  if ($$props.primaryColour === void 0 && $$bindings.primaryColour && primaryColour !== void 0)
    $$bindings.primaryColour(primaryColour);
  if ($$props.secondaryColour === void 0 && $$bindings.secondaryColour && secondaryColour !== void 0)
    $$bindings.secondaryColour(secondaryColour);
  if ($$props.thirdColour === void 0 && $$bindings.thirdColour && thirdColour !== void 0)
    $$bindings.thirdColour(thirdColour);
  return `<svg xmlns="http://www.w3.org/2000/svg"${add_attribute("class", className, 0)} fill="currentColor" viewBox="0 0 814 814"><path d="M407 33.9165C295.984 33.9165 135.667 118.708 135.667 118.708V508.75C135.667 508.75 141.044 561.82 152.625 593.541C194.871 709.259 407 780.083 407 780.083C407 780.083 619.129 709.259 661.375 593.541C672.956 561.82 678.333 508.75 678.333 508.75V118.708C678.333 118.708 518.016 33.9165 407 33.9165Z"${add_attribute("fill", primaryColour, 0)}></path><path d="M712.25 101.75V493.013C712.25 649.097 603.581 689.831 407 814C210.419 689.831 101.75 649.063 101.75 493.013V101.75C167.718 45.2448 282.729 0 407 0C531.271 0 646.282 45.2448 712.25 101.75ZM644.417 135.361C585.775 96.052 496.506 67.8333 407.237 67.8333C317.223 67.8333 228.124 96.1198 169.583 135.361V492.979C169.583 595.712 225.817 622.235 407 734.025C587.979 622.337 644.417 595.814 644.417 492.979V135.361Z"${add_attribute("fill", thirdColour, 0)}></path><path d="M407.237 135.667C464.862 135.667 527.811 150.42 576.583 174.467V493.012C576.583 547.347 562.542 558.539 407 654.422L407.237 135.667Z"${add_attribute("fill", secondaryColour, 0)}></path></svg>`;
});
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
const _page_svelte_svelte_type_style_lang = "";
const css = {
  code: ".bg-panel.svelte-phavkt{background-color:rgba(46, 50, 58, 0.9)}.circle-badge-container.svelte-phavkt{display:flex;flex-direction:column;align-items:center}.circle-badge-icon.svelte-phavkt{align-self:center}.w-v.svelte-phavkt{width:20px}",
  map: null
};
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $$unsubscribe_store;
  function createActor(options = null) {
    const hostOptions = {
      host: "http://localhost:8000"
    };
    if (!options) {
      options = { agentOptions: hostOptions };
    } else if (!options.agentOptions) {
      options.agentOptions = hostOptions;
    } else {
      options.agentOptions.host = hostOptions.host;
    }
    const agent = new HttpAgent({ ...options.agentOptions });
    return Actor.createActor(idlFactory, {
      agent,
      canisterId: { "DFX_VERSION": "0.14.4", "DFX_NETWORK": "local", "CANISTER_CANDID_PATH_OpenFPL_backend": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_OPENFPL_BACKEND": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_player_canister": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "CANISTER_CANDID_PATH_PLAYER_CANISTER": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_TOKEN_CANISTER": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_token_canister": "br5f7-7uaaa-aaaaa-qaaca-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_PLAYER_CANISTER": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_player_canister": "be2us-64aaa-aaaaa-qaabq-cai", "NNS_SNS_WASM_CANISTER_ID": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_NNS_SNS_WASM": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_nns_sns_wasm": "qaa6y-5yaaa-aaaaa-aaafa-cai", "NNS_ROOT_CANISTER_ID": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_NNS_ROOT": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_nns_root": "r7inp-6aaaa-aaaaa-aaabq-cai", "NNS_REGISTRY_CANISTER_ID": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_NNS_REGISTRY": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_nns_registry": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "NNS_LIFELINE_CANISTER_ID": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_NNS_LIFELINE": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_nns_lifeline": "rno2w-sqaaa-aaaaa-aaacq-cai", "NNS_LEDGER_CANISTER_ID": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_NNS_LEDGER": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_nns_ledger": "ryjl3-tyaaa-aaaaa-aaaba-cai", "NNS_GOVERNANCE_CANISTER_ID": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_NNS_GOVERNANCE": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_nns_governance": "rrkah-fqaaa-aaaaa-aaaaq-cai", "NNS_GENESIS_TOKEN_CANISTER_ID": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_NNS_GENESIS_TOKEN": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_nns_genesis_token": "renrk-eyaaa-aaaaa-aaada-cai", "NNS_CYCLES_MINTING_CANISTER_ID": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_NNS_CYCLES_MINTING": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_nns_cycles_minting": "rkp4c-7iaaa-aaaaa-aaaca-cai", "INTERNET_IDENTITY_CANISTER_ID": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_INTERNET_IDENTITY": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_internet_identity": "qhbym-qaaaa-aaaaa-aaafq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OPENFPL_FRONTEND": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OpenFPL_frontend": "bd3sg-teaaa-aaaaa-qaaba-cai", "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OPENFPL_BACKEND": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OpenFPL_backend": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_CANDID_PATH": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_frontend/assetstorage.did", "VITE_AUTH_PROVIDER_URL": "https://identity.ic0.app", "LESSOPEN": "| /usr/bin/lesspipe %s", "USER": "james", "npm_config_user_agent": "npm/9.5.0 node/v18.15.0 linux x64 workspaces/false", "GIT_ASKPASS": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass.sh", "npm_node_execpath": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "SHLVL": "1", "npm_config_noproxy": "", "HOME": "/home/james", "NVM_BIN": "/home/james/.nvm/versions/node/v18.15.0/bin", "TERM_PROGRAM_VERSION": "1.84.2", "VSCODE_IPC_HOOK_CLI": "/tmp/vscode-ipc-1d28369d-f4cb-4bd4-90d8-94e0a94acc50.sock", "npm_package_json": "/home/james/OpenFPL/package.json", "NVM_INC": "/home/james/.nvm/versions/node/v18.15.0/include/node", "VSCODE_GIT_ASKPASS_MAIN": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass-main.js", "VSCODE_GIT_ASKPASS_NODE": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node", "npm_config_userconfig": "/home/james/.npmrc", "npm_config_local_prefix": "/home/james/OpenFPL", "COLORTERM": "truecolor", "WSL_DISTRO_NAME": "Ubuntu", "COLOR": "0", "NVM_DIR": "/home/james/.nvm", "npm_config_metrics_registry": "https://registry.npmjs.org/", "LOGNAME": "james", "NAME": "DESKTOP-UV8C3VI", "WSL_INTEROP": "/run/WSL/12_interop", "_": "/home/james/bin/dfx", "npm_config_prefix": "/home/james/.nvm/versions/node/v18.15.0", "TERM": "xterm-256color", "npm_config_cache": "/home/james/.npm", "npm_config_node_gyp": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", "PATH": "/home/james/OpenFPL/node_modules/.bin:/home/james/node_modules/.bin:/home/node_modules/.bin:/node_modules/.bin:/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/@npmcli/run-script/lib/node-gyp-bin:/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/remote-cli:/home/james/bin:/home/james/.nvm/versions/node/v18.15.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/Microsoft/jdk-11.0.16.101-hotspot/bin:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/bin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/libnvvp:/mnt/c/Program Files (x86)/Common Files/Intel/Shared Libraries/redist/intel64/compiler:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/Nsight Compute 2020.1.2/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Git LFS:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files (x86)/ZED SDK/dependencies/freeglut_2.8/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/glew-1.12.0/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/opencv_3.1.0/x64:/mnt/c/Program Files (x86)/ZED SDK/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/Scripts/:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/james/.dotnet/tools:/mnt/c/Users/james/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/heroku/bin:/mnt/c/Users/james/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin:/mnt/c/Program Files/MongoDB/Server/4.4/bin/:/mnt/c/Users/james/AppData/Roaming/npm:/mnt/c/Users/james/.dotnet/tools:/snap/bin", "NODE": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "npm_package_name": "open_fpl_frontend", "LANG": "C.UTF-8", "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:", "TERM_PROGRAM": "vscode", "VSCODE_GIT_IPC_HANDLE": "/tmp/vscode-git-ec8aec957c.sock", "npm_lifecycle_script": "vite build", "SHELL": "/bin/bash", "npm_package_version": "0.1.0", "npm_lifecycle_event": "build", "LESSCLOSE": "/usr/bin/lesspipe %s %s", "VSCODE_GIT_ASKPASS_EXTRA_ARGS": "", "npm_config_globalconfig": "/home/james/.nvm/versions/node/v18.15.0/etc/npmrc", "npm_config_init_module": "/home/james/.npm-init.js", "PWD": "/home/james/OpenFPL", "npm_execpath": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/bin/npm-cli.js", "NVM_CD_FLAGS": "", "XDG_DATA_DIRS": "/usr/local/share:/usr/share:/var/lib/snapd/desktop", "npm_config_global_prefix": "/home/james/.nvm/versions/node/v18.15.0", "npm_command": "run-script", "HOSTTYPE": "x86_64", "WSLENV": "VSCODE_WSL_EXT_LOCATION/up", "INIT_CWD": "/home/james/OpenFPL", "EDITOR": "vi", "NODE_ENV": "production", "VITE_OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "VITE_OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "VITE___CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "VITE_PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "VITE_TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "VITE_DFX_NETWORK": "local", "VITE_HOST": "http://localhost:8000" }.BACKEND_CANISTER_ID,
      ...options?.actorOptions
    });
  }
  const store = writable({ loggedIn: false, actor: createActor() });
  $$unsubscribe_store = subscribe(store, (value) => value);
  $$result.css.add(css);
  $$unsubscribe_store();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="p-1"><div class="flex flex-col md:flex-row"><div class="flex justify-start items-center text-white space-x-4 flex-grow m-1 bg-panel p-4 rounded-md border border-gray-500 svelte-phavkt"><div class="flex-grow"><p class="text-gray-300 text-xs">Gameweek</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">12</p>
          <p class="text-gray-300 text-xs">2023/24</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Managers</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">200
          </p>
          <p class="text-gray-300 text-xs">Total</p></div>
        <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs">Weekly Prize Pool</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">0</p>
          <p class="text-gray-300 text-xs">$FPL</p></div></div>
      <div class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-1 bg-panel p-4 rounded-md border border-gray-500 svelte-phavkt"><div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs">Next Game:</p>
          <div class="flex justify-center mb-2 mt-2"><div class="flex justify-center items-center"><div class="w-10 ml-4 mr-4">${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: "#000000",
          secondaryColour: "#f3f3f3",
          thirdColour: "#211223"
        },
        {},
        {}
      )}</div>
              <div class="w-v ml-1 mr-1 flex justify-center svelte-phavkt"><p class="text-xs mt-2 mb-2 font-bold">v</p></div>
              <div class="w-10 ml-4">${validate_component(BadgeIcon, "BadgeIcon").$$render(
        $$result,
        {
          primaryColour: "#000000",
          secondaryColour: "#f3f3f3",
          thirdColour: "#211223"
        },
        {},
        {}
      )}</div></div></div>
          <div class="flex justify-center"><div class="w-10 ml-4 mr-4"><p class="text-gray-300 text-xs text-center">NEW</p></div>
            <div class="w-v ml-1 mr-1 svelte-phavkt"></div>
            <div class="w-10 ml-4"><p class="text-gray-300 text-xs text-center">ARS</p></div></div></div>
        <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>

        <div class="flex-grow mb-4 md:mb-0"><p class="text-gray-300 text-xs mt-4 md:mt-0">Kick Off:</p>
          <div class="flex"><p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">00<span class="text-gray-300 text-xs ml-1">d</span> : 18<span class="text-gray-300 text-xs ml-1">h</span>
              : 55<span class="text-gray-300 text-xs ml-1">m</span></p></div>
          <p class="text-gray-300 text-xs">Saturday November 11th, 2024</p></div>
        <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;"></div>
        <div class="flex-grow"><p class="text-gray-300 text-xs mt-4 md:mt-0">GW 11 High Score</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">Santi
          </p>
          <p class="text-gray-300 text-xs">250 points</p></div></div></div></div>

  <div class="bg-panel p-4 m-1 bg-panel p-4 rounded-md border border-gray-500 svelte-phavkt"><ul class="flex"><li class="mr-4"><button class="${escape(
        null_to_empty(`p-2 ${"text-white"}`),
        true
      ) + " svelte-phavkt"}">Fixtures
        </button></li>
      <li class="mr-4"><button class="${escape(null_to_empty(`p-2 ${"text-gray-400"}`), true) + " svelte-phavkt"}">Gameweek Points
        </button></li></ul>

    ${`${validate_component(Fixtures, "FixturesComponent").$$render($$result, {}, {}, {})}`}</div>`;
    }
  })}`;
});
export {
  Page as default
};
