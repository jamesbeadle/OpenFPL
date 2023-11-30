import { c as create_ssr_component, a as subscribe, e as escape, b as each, d as add_attribute, g as get_store_value, o as onDestroy, v as validate_component, f as noop } from "../../../chunks/index2.js";
import { p as page } from "../../../chunks/stores.js";
import { w as writable } from "../../../chunks/index.js";
import { A as ActorFactory } from "../../../chunks/team-store.js";
import "../../../chunks/fixture-store.js";
import { i as isLoading, l as loadingText, t as toastStore, L as Layout } from "../../../chunks/Layout.js";
import { a as authStore } from "../../../chunks/auth.js";
function client_method(key) {
  {
    if (key === "before_navigate" || key === "after_navigate" || key === "on_navigate") {
      return () => {
      };
    } else {
      const name_lookup = {
        disable_scroll_handling: "disableScrollHandling",
        preload_data: "preloadData",
        preload_code: "preloadCode",
        invalidate_all: "invalidateAll"
      };
      return () => {
        throw new Error(`Cannot call ${name_lookup[key] ?? key}(...) on the server`);
      };
    }
  }
}
const goto = /* @__PURE__ */ client_method("goto");
const Player_events_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $playerEventData, $$unsubscribe_playerEventData;
  let { show = false } = $$props;
  let { player } = $$props;
  let { fixtureId } = $$props;
  let { playerEventData } = $$props;
  $$unsubscribe_playerEventData = subscribe(playerEventData, (value) => $playerEventData = value);
  let eventStartTime = 0;
  let eventEndTime = 0;
  const eventOptions = [
    { id: 0, label: "Appearance" },
    { id: 1, label: "Goal Scored" },
    { id: 2, label: "Goal Assisted" },
    { id: 7, label: "Penalty Missed" },
    { id: 8, label: "Yellow Card" },
    { id: 9, label: "Red Card" },
    { id: 10, label: "Own Goal" }
  ];
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  if ($$props.player === void 0 && $$bindings.player && player !== void 0)
    $$bindings.player(player);
  if ($$props.fixtureId === void 0 && $$bindings.fixtureId && fixtureId !== void 0)
    $$bindings.fixtureId(fixtureId);
  if ($$props.playerEventData === void 0 && $$bindings.playerEventData && playerEventData !== void 0)
    $$bindings.playerEventData(playerEventData);
  $$unsubscribe_playerEventData();
  return `${show ? `<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"><div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md">${player ? `<div class="flex justify-between items-center"><h4 class="text-lg font-bold">${escape(player.firstName !== "" ? player.firstName.charAt(0) + "." : "")}
            ${escape(player.lastName)} - Match Events
          </h4>
          <button class="text-black">✕</button></div>

        <div class="mt-4 p-4 border-t border-gray-200"><h4 class="text-lg font-bold mb-3">Add Event</h4>
          <div class="flex flex-col gap-3"><div><label for="eventType" class="block text-sm font-medium text-gray-700">Event Type</label>
              <select id="eventType" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"><option value="-1" disabled>Select event type</option>${each(eventOptions, (option) => {
    return `<option${add_attribute("value", option.id, 0)}>${escape(option.label)}</option>`;
  })}</select></div>
            <div><label for="startMinute" class="block text-sm font-medium text-gray-700">Start Minute</label>
              <input type="number" id="startMinute" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md" placeholder="Enter start minute"${add_attribute("value", eventStartTime, 0)}></div>
            <div><label for="endMinute" class="block text-sm font-medium text-gray-700">End Minute</label>
              <input type="number" id="endMinute" class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md" placeholder="Enter end minute"${add_attribute("value", eventEndTime, 0)}></div>
            <button class="mt-2 px-4 py-2 bg-blue-500 text-white rounded">Add Event</button></div></div>

        <div class="mt-4"><ul class="list-disc pl-5">${each($playerEventData, (event, index) => {
    return `<li class="flex justify-between items-center mb-2"><span>${escape(event.eventType)} - From ${escape(event.eventStartMinute)} to ${escape(event.eventEndMinute)}
                  minutes</span>
                <button class="px-3 py-1 bg-red-500 text-white rounded">Remove
                </button>
              </li>`;
  })}</ul></div>` : ``}
      <div class="flex justify-end gap-3 mt-4"><button class="px-4 py-2 bg-blue-500 text-white rounded">Done</button></div></div></div>` : ``}`;
});
const Select_players_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $teamPlayers, $$unsubscribe_teamPlayers;
  let { teamPlayers = writable([]) } = $$props;
  $$unsubscribe_teamPlayers = subscribe(teamPlayers, (value) => $teamPlayers = value);
  let { selectedTeam } = $$props;
  let { selectedPlayers = writable([]) } = $$props;
  let { show = false } = $$props;
  if ($$props.teamPlayers === void 0 && $$bindings.teamPlayers && teamPlayers !== void 0)
    $$bindings.teamPlayers(teamPlayers);
  if ($$props.selectedTeam === void 0 && $$bindings.selectedTeam && selectedTeam !== void 0)
    $$bindings.selectedTeam(selectedTeam);
  if ($$props.selectedPlayers === void 0 && $$bindings.selectedPlayers && selectedPlayers !== void 0)
    $$bindings.selectedPlayers(selectedPlayers);
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  $$unsubscribe_teamPlayers();
  return `${show ? `<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"><div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md"><div class="flex justify-between items-center"><h4 class="text-lg font-bold">Select ${escape(selectedTeam.friendlyName)} Players
        </h4>
        <button class="text-black">✕</button></div>
      <div class="my-5 flex flex-wrap">${each($teamPlayers, (player) => {
    let selected = get_store_value(selectedPlayers).some((p) => p.id === player.id);
    return `
          <div class="flex-1 sm:flex-basis-1/2"><label class="block"><input type="checkbox" ${selected ? "checked" : ""}>
              ${escape(`${player.firstName.length > 0 ? player.firstName.charAt(0) + "." : ""} ${player.lastName}`)}</label>
          </div>`;
  })}</div>
      <div class="flex justify-end gap-3"><button class="px-4 py-2 border rounded text-black">Cancel</button>
        <button class="px-4 py-2 bg-blue-500 text-white rounded">Select Players</button></div></div></div>` : ``}`;
});
const Confirm_fixture_data_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { show = false } = $$props;
  let { onConfirm } = $$props;
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  return `${show ? `<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"><div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md"><div class="flex justify-between items-center"><h4 class="text-lg font-bold">Confirm Fixture Data</h4>
        <button class="text-black">✕</button></div>
      <div class="my-5"><h1>Please confirm your fixture data.</h1>
        <p class="text-sm text-gray-600">You will not be able to edit your submission and entries that differ
          from the accepted consensus data will not receive $FPL rewards. If
          consensus has already been reached for the fixture your submission
          will also not be counted.
        </p></div>
      <div class="flex justify-end gap-3"><button class="px-4 py-2 border rounded text-black">Cancel</button>
        <button class="px-4 py-2 bg-blue-500 text-white rounded">Confirm</button></div></div></div>` : ``}`;
});
const Clear_draft_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { show = false } = $$props;
  let { onConfirm } = $$props;
  if ($$props.show === void 0 && $$bindings.show && show !== void 0)
    $$bindings.show(show);
  if ($$props.onConfirm === void 0 && $$bindings.onConfirm && onConfirm !== void 0)
    $$bindings.onConfirm(onConfirm);
  return `${show ? `<div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full"><div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md"><div class="flex justify-between items-center"><h4 class="text-lg font-bold">Confirm Clear Draft</h4>
        <button class="text-black">✕</button></div>
      <div class="my-5"><h1>Please confirm you want to clear the draft from your cache.</h1></div>
      <div class="flex justify-end gap-3"><button class="px-4 py-2 border rounded text-black">Cancel</button>
        <button class="px-4 py-2 bg-blue-500 text-white rounded">Confirm</button></div></div></div>` : ``}`;
});
function createGovernanceStore() {
  const { subscribe: subscribe2, set } = writable([]);
  async function getValidatableFixtures() {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      { "DFX_VERSION": "0.14.4", "DFX_NETWORK": "ic", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "CANISTER_ID_TOKEN_CANISTER": "hwd4h-eyaaa-aaaal-qb6ra-cai", "CANISTER_ID_token_canister": "hwd4h-eyaaa-aaaal-qb6ra-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "CANISTER_ID_PLAYER_CANISTER": "pec6o-uqaaa-aaaal-qb7eq-cai", "CANISTER_ID_player_canister": "pec6o-uqaaa-aaaal-qb7eq-cai", "NNS_LEDGER_CANISTER_ID": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_NNS_LEDGER": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_nns_ledger": "ryjl3-tyaaa-aaaaa-aaaba-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "CANISTER_ID_OPENFPL_FRONTEND": "bgpwv-eqaaa-aaaal-qb6eq-cai", "CANISTER_ID_OpenFPL_frontend": "bgpwv-eqaaa-aaaal-qb6eq-cai", "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "CANISTER_ID_OPENFPL_BACKEND": "bboqb-jiaaa-aaaal-qb6ea-cai", "CANISTER_ID_OpenFPL_backend": "bboqb-jiaaa-aaaal-qb6ea-cai", "CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "CANISTER_CANDID_PATH": "/home/james/OpenFPL/.dfx/ic/canisters/OpenFPL_frontend/assetstorage.did", "VITE_AUTH_PROVIDER_URL": "https://identity.ic0.app", "LESSOPEN": "| /usr/bin/lesspipe %s", "USER": "james", "npm_config_user_agent": "npm/9.5.0 node/v18.15.0 linux x64 workspaces/false", "GIT_ASKPASS": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass.sh", "npm_node_execpath": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "SHLVL": "1", "npm_config_noproxy": "", "MOTD_SHOWN": "update-motd", "HOME": "/home/james", "TERM_PROGRAM_VERSION": "1.84.2", "NVM_BIN": "/home/james/.nvm/versions/node/v18.15.0/bin", "VSCODE_IPC_HOOK_CLI": "/tmp/vscode-ipc-55e74069-e243-4d5e-85c2-180e79128070.sock", "npm_package_json": "/home/james/OpenFPL/package.json", "NVM_INC": "/home/james/.nvm/versions/node/v18.15.0/include/node", "VSCODE_GIT_ASKPASS_MAIN": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass-main.js", "VSCODE_GIT_ASKPASS_NODE": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node", "npm_config_userconfig": "/home/james/.npmrc", "npm_config_local_prefix": "/home/james/OpenFPL", "COLORTERM": "truecolor", "WSL_DISTRO_NAME": "Ubuntu", "COLOR": "1", "NVM_DIR": "/home/james/.nvm", "npm_config_metrics_registry": "https://registry.npmjs.org/", "LOGNAME": "james", "NAME": "DESKTOP-UV8C3VI", "WSL_INTEROP": "/run/WSL/12_interop", "_": "/home/james/.nvm/versions/node/v18.15.0/bin/npm", "npm_config_prefix": "/home/james/.nvm/versions/node/v18.15.0", "TERM": "xterm-256color", "npm_config_cache": "/home/james/.npm", "npm_config_node_gyp": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", "PATH": "/home/james/OpenFPL/node_modules/.bin:/home/james/node_modules/.bin:/home/node_modules/.bin:/node_modules/.bin:/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/@npmcli/run-script/lib/node-gyp-bin:/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/remote-cli:/home/james/bin:/home/james/.nvm/versions/node/v18.15.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/Microsoft/jdk-11.0.16.101-hotspot/bin:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/bin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/libnvvp:/mnt/c/Program Files (x86)/Common Files/Intel/Shared Libraries/redist/intel64/compiler:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/Nsight Compute 2020.1.2/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Git LFS:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files (x86)/ZED SDK/dependencies/freeglut_2.8/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/glew-1.12.0/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/opencv_3.1.0/x64:/mnt/c/Program Files (x86)/ZED SDK/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/Scripts/:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/james/.dotnet/tools:/mnt/c/Users/james/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/heroku/bin:/mnt/c/Users/james/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin:/mnt/c/Program Files/MongoDB/Server/4.4/bin/:/mnt/c/Users/james/AppData/Roaming/npm:/mnt/c/Users/james/.dotnet/tools:/snap/bin", "NODE": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "npm_package_name": "open_fpl_frontend", "LANG": "C.UTF-8", "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:", "VSCODE_GIT_IPC_HANDLE": "/tmp/vscode-git-ec8aec957c.sock", "TERM_PROGRAM": "vscode", "npm_lifecycle_script": "vite build", "SHELL": "/bin/bash", "npm_package_version": "0.1.0", "npm_lifecycle_event": "build", "LESSCLOSE": "/usr/bin/lesspipe %s %s", "VSCODE_GIT_ASKPASS_EXTRA_ARGS": "", "npm_config_globalconfig": "/home/james/.nvm/versions/node/v18.15.0/etc/npmrc", "npm_config_init_module": "/home/james/.npm-init.js", "PWD": "/home/james/OpenFPL", "npm_execpath": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/bin/npm-cli.js", "NVM_CD_FLAGS": "", "XDG_DATA_DIRS": "/usr/local/share:/usr/share:/var/lib/snapd/desktop", "npm_config_global_prefix": "/home/james/.nvm/versions/node/v18.15.0", "npm_command": "run-script", "HOSTTYPE": "x86_64", "WSLENV": "VSCODE_WSL_EXT_LOCATION/up", "INIT_CWD": "/home/james/OpenFPL", "EDITOR": "vi", "NODE_ENV": "production", "VITE_OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "VITE_OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "VITE___CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "VITE_PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "VITE_TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "VITE_DFX_NETWORK": "local", "VITE_HOST": "http://localhost:8000" }.OPENFPL_BACKEND_CANISTER_ID
    );
    const fixtures = await identityActor.getValidatableFixtures();
    set(fixtures);
    return fixtures;
  }
  async function submitFixtureData(fixtureId, allPlayerEvents) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "DFX_VERSION": "0.14.4", "DFX_NETWORK": "ic", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "CANISTER_ID_TOKEN_CANISTER": "hwd4h-eyaaa-aaaal-qb6ra-cai", "CANISTER_ID_token_canister": "hwd4h-eyaaa-aaaal-qb6ra-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "CANISTER_ID_PLAYER_CANISTER": "pec6o-uqaaa-aaaal-qb7eq-cai", "CANISTER_ID_player_canister": "pec6o-uqaaa-aaaal-qb7eq-cai", "NNS_LEDGER_CANISTER_ID": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_NNS_LEDGER": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_nns_ledger": "ryjl3-tyaaa-aaaaa-aaaba-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "CANISTER_ID_OPENFPL_FRONTEND": "bgpwv-eqaaa-aaaal-qb6eq-cai", "CANISTER_ID_OpenFPL_frontend": "bgpwv-eqaaa-aaaal-qb6eq-cai", "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "CANISTER_ID_OPENFPL_BACKEND": "bboqb-jiaaa-aaaal-qb6ea-cai", "CANISTER_ID_OpenFPL_backend": "bboqb-jiaaa-aaaal-qb6ea-cai", "CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "CANISTER_CANDID_PATH": "/home/james/OpenFPL/.dfx/ic/canisters/OpenFPL_frontend/assetstorage.did", "VITE_AUTH_PROVIDER_URL": "https://identity.ic0.app", "LESSOPEN": "| /usr/bin/lesspipe %s", "USER": "james", "npm_config_user_agent": "npm/9.5.0 node/v18.15.0 linux x64 workspaces/false", "GIT_ASKPASS": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass.sh", "npm_node_execpath": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "SHLVL": "1", "npm_config_noproxy": "", "MOTD_SHOWN": "update-motd", "HOME": "/home/james", "TERM_PROGRAM_VERSION": "1.84.2", "NVM_BIN": "/home/james/.nvm/versions/node/v18.15.0/bin", "VSCODE_IPC_HOOK_CLI": "/tmp/vscode-ipc-55e74069-e243-4d5e-85c2-180e79128070.sock", "npm_package_json": "/home/james/OpenFPL/package.json", "NVM_INC": "/home/james/.nvm/versions/node/v18.15.0/include/node", "VSCODE_GIT_ASKPASS_MAIN": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass-main.js", "VSCODE_GIT_ASKPASS_NODE": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node", "npm_config_userconfig": "/home/james/.npmrc", "npm_config_local_prefix": "/home/james/OpenFPL", "COLORTERM": "truecolor", "WSL_DISTRO_NAME": "Ubuntu", "COLOR": "1", "NVM_DIR": "/home/james/.nvm", "npm_config_metrics_registry": "https://registry.npmjs.org/", "LOGNAME": "james", "NAME": "DESKTOP-UV8C3VI", "WSL_INTEROP": "/run/WSL/12_interop", "_": "/home/james/.nvm/versions/node/v18.15.0/bin/npm", "npm_config_prefix": "/home/james/.nvm/versions/node/v18.15.0", "TERM": "xterm-256color", "npm_config_cache": "/home/james/.npm", "npm_config_node_gyp": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", "PATH": "/home/james/OpenFPL/node_modules/.bin:/home/james/node_modules/.bin:/home/node_modules/.bin:/node_modules/.bin:/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/@npmcli/run-script/lib/node-gyp-bin:/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/remote-cli:/home/james/bin:/home/james/.nvm/versions/node/v18.15.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/Microsoft/jdk-11.0.16.101-hotspot/bin:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/bin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/libnvvp:/mnt/c/Program Files (x86)/Common Files/Intel/Shared Libraries/redist/intel64/compiler:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/Nsight Compute 2020.1.2/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Git LFS:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files (x86)/ZED SDK/dependencies/freeglut_2.8/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/glew-1.12.0/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/opencv_3.1.0/x64:/mnt/c/Program Files (x86)/ZED SDK/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/Scripts/:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/james/.dotnet/tools:/mnt/c/Users/james/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/heroku/bin:/mnt/c/Users/james/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin:/mnt/c/Program Files/MongoDB/Server/4.4/bin/:/mnt/c/Users/james/AppData/Roaming/npm:/mnt/c/Users/james/.dotnet/tools:/snap/bin", "NODE": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "npm_package_name": "open_fpl_frontend", "LANG": "C.UTF-8", "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:", "VSCODE_GIT_IPC_HANDLE": "/tmp/vscode-git-ec8aec957c.sock", "TERM_PROGRAM": "vscode", "npm_lifecycle_script": "vite build", "SHELL": "/bin/bash", "npm_package_version": "0.1.0", "npm_lifecycle_event": "build", "LESSCLOSE": "/usr/bin/lesspipe %s %s", "VSCODE_GIT_ASKPASS_EXTRA_ARGS": "", "npm_config_globalconfig": "/home/james/.nvm/versions/node/v18.15.0/etc/npmrc", "npm_config_init_module": "/home/james/.npm-init.js", "PWD": "/home/james/OpenFPL", "npm_execpath": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/bin/npm-cli.js", "NVM_CD_FLAGS": "", "XDG_DATA_DIRS": "/usr/local/share:/usr/share:/var/lib/snapd/desktop", "npm_config_global_prefix": "/home/james/.nvm/versions/node/v18.15.0", "npm_command": "run-script", "HOSTTYPE": "x86_64", "WSLENV": "VSCODE_WSL_EXT_LOCATION/up", "INIT_CWD": "/home/james/OpenFPL", "EDITOR": "vi", "NODE_ENV": "production", "VITE_OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "VITE_OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "VITE___CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "VITE_PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "VITE_TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "VITE_DFX_NETWORK": "local", "VITE_HOST": "http://localhost:8000" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.submitFixtureData(fixtureId, allPlayerEvents);
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }
  return {
    subscribe: subscribe2,
    getValidatableFixtures,
    submitFixtureData
  };
}
const governanceStore = createGovernanceStore();
let showPlayerSelectionModal = false;
let showClearDraftModal = false;
let showConfirmDataModal = false;
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let fixtureId;
  let $page, $$unsubscribe_page;
  let $selectedPlayers, $$unsubscribe_selectedPlayers;
  let $playerEventData, $$unsubscribe_playerEventData = noop, $$subscribe_playerEventData = () => ($$unsubscribe_playerEventData(), $$unsubscribe_playerEventData = subscribe(playerEventData, ($$value) => $playerEventData = $$value), playerEventData);
  $$unsubscribe_page = subscribe(page, (value) => $page = value);
  let teams;
  let fixture;
  let showPlayerEventModal = false;
  let teamPlayers = writable([]);
  let selectedPlayers = writable([]);
  $$unsubscribe_selectedPlayers = subscribe(selectedPlayers, (value) => $selectedPlayers = value);
  let selectedTeam;
  let selectedPlayer;
  let playerEventData = writable([]);
  $$subscribe_playerEventData();
  onDestroy(() => {
  });
  async function confirmFixtureData() {
    isLoading.set(true);
    loadingText.set("Saving Fixture Data");
    try {
      await governanceStore.submitFixtureData(fixtureId, get_store_value(playerEventData));
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
      toastStore.show("Fixture data saved", "success");
      goto("/fixture-validation");
    } catch (error) {
      toastStore.show("Error saving fixture data.", "error");
      console.error("Error saving fixture data: ", error);
    } finally {
      isLoading.set(false);
      loadingText.set("Loading");
    }
  }
  function clearDraft() {
    $$subscribe_playerEventData(playerEventData = writable([]));
    localStorage.removeItem(`fixtureDraft_${fixtureId}`);
    toastStore.show("Draft cleared.", "success");
  }
  function getTeamFromId(teamId) {
    return teams.find((team) => team.id === teamId);
  }
  fixtureId = Number($page.url.searchParams.get("id"));
  $$unsubscribe_page();
  $$unsubscribe_selectedPlayers();
  $$unsubscribe_playerEventData();
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `${isLoading ? `<div class="flex items-center justify-center h-screen"><p class="text-center mt-1">Loading Fixture Data...</p></div>` : `<div class="m-4"><button class="fpl-button">Save Draft</button>
      <div class="bg-panel rounded-lg m-4"><ul class="flex rounded-t-lg bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-base ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>${escape(getTeamFromId(0)?.friendlyName)}</button></li>
          <li${add_attribute("class", `mr-4 text-xs md:text-base ${""}`, 0)}><button${add_attribute("class", `p-2 ${"text-gray-400"}`, 0)}>${escape(getTeamFromId(0)?.friendlyName)}</button></li></ul>

        ${`${each($selectedPlayers.filter((x) => x.teamId === fixture?.homeTeamId), (player) => {
        return `<div class="card player-card mb-4"><div class="card-header"><h5>${escape(player.lastName)}</h5>
                <p class="small-text mb-0 mt-0">${escape(player.firstName)}</p></div>
              <div class="card-body"><p>Events: ${escape($playerEventData.filter((pe) => pe.playerId === player.id).length)}</p>
                <button>Update</button></div>
            </div>`;
      })}`}</div></div>`}`;
    }
  })}

${validate_component(Select_players_modal, "SelectPlayersModal").$$render(
    $$result,
    {
      show: showPlayerSelectionModal,
      teamPlayers,
      selectedTeam,
      selectedPlayers
    },
    {},
    {}
  )}
${validate_component(Player_events_modal, "PlayerEventsModal").$$render(
    $$result,
    {
      show: showPlayerEventModal,
      player: selectedPlayer,
      fixtureId,
      playerEventData
    },
    {},
    {}
  )}
${validate_component(Confirm_fixture_data_modal, "ConfirmFixtureDataModal").$$render(
    $$result,
    {
      show: showConfirmDataModal,
      onConfirm: confirmFixtureData
    },
    {},
    {}
  )}
${validate_component(Clear_draft_modal, "ClearDraftModal").$$render(
    $$result,
    {
      show: showClearDraftModal,
      onConfirm: clearDraft
    },
    {},
    {}
  )}`;
});
export {
  Page as default
};
