import "@dfinity/agent";
import { A as ActorFactory } from "./LoadingIcon.js";
import { r as replacer, S as SystemService } from "./TeamService.js";
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
class PlayerService {
  actor;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      { "DFX_VERSION": "0.14.4", "DFX_NETWORK": "local", "CANISTER_CANDID_PATH_OpenFPL_backend": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_OPENFPL_BACKEND": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_player_canister": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "CANISTER_CANDID_PATH_PLAYER_CANISTER": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_TOKEN_CANISTER": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_token_canister": "br5f7-7uaaa-aaaaa-qaaca-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_PLAYER_CANISTER": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_player_canister": "be2us-64aaa-aaaaa-qaabq-cai", "NNS_SNS_WASM_CANISTER_ID": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_NNS_SNS_WASM": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_nns_sns_wasm": "qaa6y-5yaaa-aaaaa-aaafa-cai", "NNS_ROOT_CANISTER_ID": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_NNS_ROOT": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_nns_root": "r7inp-6aaaa-aaaaa-aaabq-cai", "NNS_REGISTRY_CANISTER_ID": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_NNS_REGISTRY": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_nns_registry": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "NNS_LIFELINE_CANISTER_ID": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_NNS_LIFELINE": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_nns_lifeline": "rno2w-sqaaa-aaaaa-aaacq-cai", "NNS_LEDGER_CANISTER_ID": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_NNS_LEDGER": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_nns_ledger": "ryjl3-tyaaa-aaaaa-aaaba-cai", "NNS_GOVERNANCE_CANISTER_ID": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_NNS_GOVERNANCE": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_nns_governance": "rrkah-fqaaa-aaaaa-aaaaq-cai", "NNS_GENESIS_TOKEN_CANISTER_ID": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_NNS_GENESIS_TOKEN": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_nns_genesis_token": "renrk-eyaaa-aaaaa-aaada-cai", "NNS_CYCLES_MINTING_CANISTER_ID": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_NNS_CYCLES_MINTING": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_nns_cycles_minting": "rkp4c-7iaaa-aaaaa-aaaca-cai", "INTERNET_IDENTITY_CANISTER_ID": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_INTERNET_IDENTITY": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_internet_identity": "qhbym-qaaaa-aaaaa-aaafq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OPENFPL_FRONTEND": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OpenFPL_frontend": "bd3sg-teaaa-aaaaa-qaaba-cai", "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OPENFPL_BACKEND": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OpenFPL_backend": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_CANDID_PATH": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_frontend/assetstorage.did", "VITE_AUTH_PROVIDER_URL": "https://identity.ic0.app", "LESSOPEN": "| /usr/bin/lesspipe %s", "USER": "james", "npm_config_user_agent": "npm/9.5.0 node/v18.15.0 linux x64 workspaces/false", "GIT_ASKPASS": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass.sh", "npm_node_execpath": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "SHLVL": "1", "npm_config_noproxy": "", "HOME": "/home/james", "NVM_BIN": "/home/james/.nvm/versions/node/v18.15.0/bin", "TERM_PROGRAM_VERSION": "1.84.2", "VSCODE_IPC_HOOK_CLI": "/tmp/vscode-ipc-0753b78d-3c77-44d7-880e-35a1b215d5d4.sock", "npm_package_json": "/home/james/OpenFPL/package.json", "NVM_INC": "/home/james/.nvm/versions/node/v18.15.0/include/node", "VSCODE_GIT_ASKPASS_MAIN": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass-main.js", "VSCODE_GIT_ASKPASS_NODE": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node", "npm_config_userconfig": "/home/james/.npmrc", "npm_config_local_prefix": "/home/james/OpenFPL", "COLORTERM": "truecolor", "WSL_DISTRO_NAME": "Ubuntu", "COLOR": "0", "NVM_DIR": "/home/james/.nvm", "npm_config_metrics_registry": "https://registry.npmjs.org/", "LOGNAME": "james", "NAME": "DESKTOP-UV8C3VI", "WSL_INTEROP": "/run/WSL/12_interop", "_": "/home/james/bin/dfx", "npm_config_prefix": "/home/james/.nvm/versions/node/v18.15.0", "TERM": "xterm-256color", "npm_config_cache": "/home/james/.npm", "npm_config_node_gyp": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", "PATH": "/home/james/OpenFPL/node_modules/.bin:/home/james/node_modules/.bin:/home/node_modules/.bin:/node_modules/.bin:/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/@npmcli/run-script/lib/node-gyp-bin:/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/remote-cli:/home/james/bin:/home/james/.nvm/versions/node/v18.15.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/Microsoft/jdk-11.0.16.101-hotspot/bin:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/bin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/libnvvp:/mnt/c/Program Files (x86)/Common Files/Intel/Shared Libraries/redist/intel64/compiler:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/Nsight Compute 2020.1.2/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Git LFS:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files (x86)/ZED SDK/dependencies/freeglut_2.8/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/glew-1.12.0/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/opencv_3.1.0/x64:/mnt/c/Program Files (x86)/ZED SDK/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/Scripts/:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/james/.dotnet/tools:/mnt/c/Users/james/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/heroku/bin:/mnt/c/Users/james/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin:/mnt/c/Program Files/MongoDB/Server/4.4/bin/:/mnt/c/Users/james/AppData/Roaming/npm:/mnt/c/Users/james/.dotnet/tools:/snap/bin", "NODE": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "npm_package_name": "open_fpl_frontend", "LANG": "C.UTF-8", "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:", "TERM_PROGRAM": "vscode", "VSCODE_GIT_IPC_HANDLE": "/tmp/vscode-git-ec8aec957c.sock", "npm_lifecycle_script": "vite build", "SHELL": "/bin/bash", "npm_package_version": "0.1.0", "npm_lifecycle_event": "build", "LESSCLOSE": "/usr/bin/lesspipe %s %s", "VSCODE_GIT_ASKPASS_EXTRA_ARGS": "", "npm_config_globalconfig": "/home/james/.nvm/versions/node/v18.15.0/etc/npmrc", "npm_config_init_module": "/home/james/.npm-init.js", "PWD": "/home/james/OpenFPL", "npm_execpath": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/bin/npm-cli.js", "NVM_CD_FLAGS": "", "XDG_DATA_DIRS": "/usr/local/share:/usr/share:/var/lib/snapd/desktop", "npm_config_global_prefix": "/home/james/.nvm/versions/node/v18.15.0", "npm_command": "run-script", "HOSTTYPE": "x86_64", "WSLENV": "VSCODE_WSL_EXT_LOCATION/up", "INIT_CWD": "/home/james/OpenFPL", "EDITOR": "vi", "NODE_ENV": "production", "VITE_OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "VITE_OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "VITE___CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "VITE_PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "VITE_TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "VITE_DFX_NETWORK": "local", "VITE_HOST": "http://localhost:8000" }.PLAYER_CANISTER_CANISTER_ID
    );
  }
  async updatePlayersData() {
    let category = "players";
    const newHashValues = await this.actor.getDataHashes();
    let livePlayersHash = newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (livePlayersHash?.hash != localHash) {
      let updatedPlayersData = await this.actor.getAllPlayers();
      localStorage.setItem(
        "players_data",
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
    }
  }
  async getPlayers() {
    const cachedPlayersData = localStorage.getItem("players_data");
    let cachedPlayers;
    try {
      cachedPlayers = JSON.parse(cachedPlayersData || "[]");
    } catch (e) {
      cachedPlayers = [];
    }
    return cachedPlayers;
  }
  async updatePlayerEventsData() {
    let category = "player_events";
    const newHashValues = await this.actor.getDataHashes();
    let livePlayersHash = newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (livePlayersHash?.hash != localHash) {
      let systemService = new SystemService();
      await systemService.updateSystemStateData();
      let systemState = await systemService.getSystemState();
      let updatedPlayersData = await this.actor.getAllPlayersMap(
        systemState?.activeSeason?.id,
        systemState?.activeGameweek
      );
      localStorage.setItem(
        "players_data",
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
    }
  }
  async getPlayerEvents() {
    const cachedPlayerEventsData = localStorage.getItem("player_events_data");
    let cachedPlayerEvents;
    try {
      cachedPlayerEvents = JSON.parse(cachedPlayerEventsData || "[]");
    } catch (e) {
      cachedPlayerEvents = [];
    }
    return cachedPlayerEvents;
  }
  async getPlayerDetails(playerId, seasonId) {
    try {
      const playerDetailData = await this.actor.getPlayerDetails(
        playerId,
        seasonId
      );
      return playerDetailData;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }
}
export {
  PlayerService as P
};
