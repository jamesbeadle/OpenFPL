import { c as create_ssr_component, e as escape, n as null_to_empty, d as add_attribute, o as onDestroy, b as each, a as subscribe, v as validate_component } from "../../../chunks/index3.js";
import "../../../chunks/index.js";
import "../../../chunks/system-store.js";
import "../../../chunks/manager-store.js";
import { a as LoadingIcon, t as toastStore, L as Layout } from "../../../chunks/Layout.js";
import { a as authStore } from "../../../chunks/auth.js";
import { w as writable } from "../../../chunks/index2.js";
import { A as ActorFactory } from "../../../chunks/team-store.js";
import "../../../chunks/app.constants.js";
import "@dfinity/auth-client";
import "@dfinity/utils";
import "@dfinity/agent";
function createUserStore() {
  const { subscribe: subscribe2, set, update } = writable(null);
  async function updateUsername(username) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "DFX_VERSION": "0.14.4", "DFX_NETWORK": "local", "CANISTER_CANDID_PATH_OpenFPL_backend": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_OPENFPL_BACKEND": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_player_canister": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "CANISTER_CANDID_PATH_PLAYER_CANISTER": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_TOKEN_CANISTER": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_token_canister": "br5f7-7uaaa-aaaaa-qaaca-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_PLAYER_CANISTER": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_player_canister": "be2us-64aaa-aaaaa-qaabq-cai", "NNS_SNS_WASM_CANISTER_ID": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_NNS_SNS_WASM": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_nns_sns_wasm": "qaa6y-5yaaa-aaaaa-aaafa-cai", "NNS_ROOT_CANISTER_ID": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_NNS_ROOT": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_nns_root": "r7inp-6aaaa-aaaaa-aaabq-cai", "NNS_REGISTRY_CANISTER_ID": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_NNS_REGISTRY": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_nns_registry": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "NNS_LIFELINE_CANISTER_ID": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_NNS_LIFELINE": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_nns_lifeline": "rno2w-sqaaa-aaaaa-aaacq-cai", "NNS_LEDGER_CANISTER_ID": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_NNS_LEDGER": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_nns_ledger": "ryjl3-tyaaa-aaaaa-aaaba-cai", "NNS_GOVERNANCE_CANISTER_ID": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_NNS_GOVERNANCE": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_nns_governance": "rrkah-fqaaa-aaaaa-aaaaq-cai", "NNS_GENESIS_TOKEN_CANISTER_ID": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_NNS_GENESIS_TOKEN": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_nns_genesis_token": "renrk-eyaaa-aaaaa-aaada-cai", "NNS_CYCLES_MINTING_CANISTER_ID": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_NNS_CYCLES_MINTING": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_nns_cycles_minting": "rkp4c-7iaaa-aaaaa-aaaca-cai", "INTERNET_IDENTITY_CANISTER_ID": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_INTERNET_IDENTITY": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_internet_identity": "qhbym-qaaaa-aaaaa-aaafq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OPENFPL_FRONTEND": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OpenFPL_frontend": "bd3sg-teaaa-aaaaa-qaaba-cai", "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OPENFPL_BACKEND": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OpenFPL_backend": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_CANDID_PATH": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_frontend/assetstorage.did", "VITE_AUTH_PROVIDER_URL": "https://identity.ic0.app", "LESSOPEN": "| /usr/bin/lesspipe %s", "USER": "james", "npm_config_user_agent": "npm/9.5.0 node/v18.15.0 linux x64 workspaces/false", "GIT_ASKPASS": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass.sh", "npm_node_execpath": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "SHLVL": "1", "npm_config_noproxy": "", "HOME": "/home/james", "MOTD_SHOWN": "update-motd", "NVM_BIN": "/home/james/.nvm/versions/node/v18.15.0/bin", "TERM_PROGRAM_VERSION": "1.84.2", "VSCODE_IPC_HOOK_CLI": "/tmp/vscode-ipc-a6ec3a05-a494-491b-8658-e2826d0ed848.sock", "npm_package_json": "/home/james/OpenFPL/package.json", "NVM_INC": "/home/james/.nvm/versions/node/v18.15.0/include/node", "VSCODE_GIT_ASKPASS_MAIN": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass-main.js", "VSCODE_GIT_ASKPASS_NODE": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node", "npm_config_userconfig": "/home/james/.npmrc", "npm_config_local_prefix": "/home/james/OpenFPL", "COLORTERM": "truecolor", "WSL_DISTRO_NAME": "Ubuntu", "COLOR": "0", "NVM_DIR": "/home/james/.nvm", "npm_config_metrics_registry": "https://registry.npmjs.org/", "LOGNAME": "james", "NAME": "DESKTOP-UV8C3VI", "WSL_INTEROP": "/run/WSL/12_interop", "_": "/home/james/bin/dfx", "npm_config_prefix": "/home/james/.nvm/versions/node/v18.15.0", "TERM": "xterm-256color", "npm_config_cache": "/home/james/.npm", "npm_config_node_gyp": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", "PATH": "/home/james/OpenFPL/node_modules/.bin:/home/james/node_modules/.bin:/home/node_modules/.bin:/node_modules/.bin:/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/@npmcli/run-script/lib/node-gyp-bin:/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/remote-cli:/home/james/bin:/home/james/.nvm/versions/node/v18.15.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/Microsoft/jdk-11.0.16.101-hotspot/bin:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/bin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/libnvvp:/mnt/c/Program Files (x86)/Common Files/Intel/Shared Libraries/redist/intel64/compiler:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/Nsight Compute 2020.1.2/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Git LFS:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files (x86)/ZED SDK/dependencies/freeglut_2.8/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/glew-1.12.0/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/opencv_3.1.0/x64:/mnt/c/Program Files (x86)/ZED SDK/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/Scripts/:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/james/.dotnet/tools:/mnt/c/Users/james/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/heroku/bin:/mnt/c/Users/james/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin:/mnt/c/Program Files/MongoDB/Server/4.4/bin/:/mnt/c/Users/james/AppData/Roaming/npm:/mnt/c/Users/james/.dotnet/tools:/snap/bin", "NODE": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "npm_package_name": "open_fpl_frontend", "LANG": "C.UTF-8", "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:", "TERM_PROGRAM": "vscode", "VSCODE_GIT_IPC_HANDLE": "/tmp/vscode-git-ec8aec957c.sock", "npm_lifecycle_script": "vite build", "SHELL": "/bin/bash", "npm_package_version": "0.1.0", "npm_lifecycle_event": "build", "LESSCLOSE": "/usr/bin/lesspipe %s %s", "VSCODE_GIT_ASKPASS_EXTRA_ARGS": "", "npm_config_globalconfig": "/home/james/.nvm/versions/node/v18.15.0/etc/npmrc", "npm_config_init_module": "/home/james/.npm-init.js", "PWD": "/home/james/OpenFPL", "npm_execpath": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/bin/npm-cli.js", "NVM_CD_FLAGS": "", "XDG_DATA_DIRS": "/usr/local/share:/usr/share:/var/lib/snapd/desktop", "npm_config_global_prefix": "/home/james/.nvm/versions/node/v18.15.0", "npm_command": "run-script", "HOSTTYPE": "x86_64", "WSLENV": "VSCODE_WSL_EXT_LOCATION/up", "INIT_CWD": "/home/james/OpenFPL", "EDITOR": "vi", "NODE_ENV": "production", "VITE_OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "VITE_OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "VITE___CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "VITE_PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "VITE_TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "VITE_DFX_NETWORK": "local", "VITE_HOST": "http://localhost:8000" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.updateDisplayName(username);
      return result;
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }
  async function updateFavouriteTeam(favouriteTeamId) {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "DFX_VERSION": "0.14.4", "DFX_NETWORK": "local", "CANISTER_CANDID_PATH_OpenFPL_backend": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_OPENFPL_BACKEND": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_player_canister": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "CANISTER_CANDID_PATH_PLAYER_CANISTER": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_TOKEN_CANISTER": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_token_canister": "br5f7-7uaaa-aaaaa-qaaca-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_PLAYER_CANISTER": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_player_canister": "be2us-64aaa-aaaaa-qaabq-cai", "NNS_SNS_WASM_CANISTER_ID": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_NNS_SNS_WASM": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_nns_sns_wasm": "qaa6y-5yaaa-aaaaa-aaafa-cai", "NNS_ROOT_CANISTER_ID": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_NNS_ROOT": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_nns_root": "r7inp-6aaaa-aaaaa-aaabq-cai", "NNS_REGISTRY_CANISTER_ID": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_NNS_REGISTRY": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_nns_registry": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "NNS_LIFELINE_CANISTER_ID": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_NNS_LIFELINE": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_nns_lifeline": "rno2w-sqaaa-aaaaa-aaacq-cai", "NNS_LEDGER_CANISTER_ID": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_NNS_LEDGER": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_nns_ledger": "ryjl3-tyaaa-aaaaa-aaaba-cai", "NNS_GOVERNANCE_CANISTER_ID": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_NNS_GOVERNANCE": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_nns_governance": "rrkah-fqaaa-aaaaa-aaaaq-cai", "NNS_GENESIS_TOKEN_CANISTER_ID": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_NNS_GENESIS_TOKEN": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_nns_genesis_token": "renrk-eyaaa-aaaaa-aaada-cai", "NNS_CYCLES_MINTING_CANISTER_ID": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_NNS_CYCLES_MINTING": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_nns_cycles_minting": "rkp4c-7iaaa-aaaaa-aaaca-cai", "INTERNET_IDENTITY_CANISTER_ID": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_INTERNET_IDENTITY": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_internet_identity": "qhbym-qaaaa-aaaaa-aaafq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OPENFPL_FRONTEND": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OpenFPL_frontend": "bd3sg-teaaa-aaaaa-qaaba-cai", "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OPENFPL_BACKEND": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OpenFPL_backend": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_CANDID_PATH": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_frontend/assetstorage.did", "VITE_AUTH_PROVIDER_URL": "https://identity.ic0.app", "LESSOPEN": "| /usr/bin/lesspipe %s", "USER": "james", "npm_config_user_agent": "npm/9.5.0 node/v18.15.0 linux x64 workspaces/false", "GIT_ASKPASS": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass.sh", "npm_node_execpath": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "SHLVL": "1", "npm_config_noproxy": "", "HOME": "/home/james", "MOTD_SHOWN": "update-motd", "NVM_BIN": "/home/james/.nvm/versions/node/v18.15.0/bin", "TERM_PROGRAM_VERSION": "1.84.2", "VSCODE_IPC_HOOK_CLI": "/tmp/vscode-ipc-a6ec3a05-a494-491b-8658-e2826d0ed848.sock", "npm_package_json": "/home/james/OpenFPL/package.json", "NVM_INC": "/home/james/.nvm/versions/node/v18.15.0/include/node", "VSCODE_GIT_ASKPASS_MAIN": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass-main.js", "VSCODE_GIT_ASKPASS_NODE": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node", "npm_config_userconfig": "/home/james/.npmrc", "npm_config_local_prefix": "/home/james/OpenFPL", "COLORTERM": "truecolor", "WSL_DISTRO_NAME": "Ubuntu", "COLOR": "0", "NVM_DIR": "/home/james/.nvm", "npm_config_metrics_registry": "https://registry.npmjs.org/", "LOGNAME": "james", "NAME": "DESKTOP-UV8C3VI", "WSL_INTEROP": "/run/WSL/12_interop", "_": "/home/james/bin/dfx", "npm_config_prefix": "/home/james/.nvm/versions/node/v18.15.0", "TERM": "xterm-256color", "npm_config_cache": "/home/james/.npm", "npm_config_node_gyp": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", "PATH": "/home/james/OpenFPL/node_modules/.bin:/home/james/node_modules/.bin:/home/node_modules/.bin:/node_modules/.bin:/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/@npmcli/run-script/lib/node-gyp-bin:/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/remote-cli:/home/james/bin:/home/james/.nvm/versions/node/v18.15.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/Microsoft/jdk-11.0.16.101-hotspot/bin:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/bin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/libnvvp:/mnt/c/Program Files (x86)/Common Files/Intel/Shared Libraries/redist/intel64/compiler:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/Nsight Compute 2020.1.2/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Git LFS:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files (x86)/ZED SDK/dependencies/freeglut_2.8/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/glew-1.12.0/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/opencv_3.1.0/x64:/mnt/c/Program Files (x86)/ZED SDK/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/Scripts/:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/james/.dotnet/tools:/mnt/c/Users/james/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/heroku/bin:/mnt/c/Users/james/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin:/mnt/c/Program Files/MongoDB/Server/4.4/bin/:/mnt/c/Users/james/AppData/Roaming/npm:/mnt/c/Users/james/.dotnet/tools:/snap/bin", "NODE": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "npm_package_name": "open_fpl_frontend", "LANG": "C.UTF-8", "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:", "TERM_PROGRAM": "vscode", "VSCODE_GIT_IPC_HANDLE": "/tmp/vscode-git-ec8aec957c.sock", "npm_lifecycle_script": "vite build", "SHELL": "/bin/bash", "npm_package_version": "0.1.0", "npm_lifecycle_event": "build", "LESSCLOSE": "/usr/bin/lesspipe %s %s", "VSCODE_GIT_ASKPASS_EXTRA_ARGS": "", "npm_config_globalconfig": "/home/james/.nvm/versions/node/v18.15.0/etc/npmrc", "npm_config_init_module": "/home/james/.npm-init.js", "PWD": "/home/james/OpenFPL", "npm_execpath": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/bin/npm-cli.js", "NVM_CD_FLAGS": "", "XDG_DATA_DIRS": "/usr/local/share:/usr/share:/var/lib/snapd/desktop", "npm_config_global_prefix": "/home/james/.nvm/versions/node/v18.15.0", "npm_command": "run-script", "HOSTTYPE": "x86_64", "WSLENV": "VSCODE_WSL_EXT_LOCATION/up", "INIT_CWD": "/home/james/OpenFPL", "EDITOR": "vi", "NODE_ENV": "production", "VITE_OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "VITE_OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "VITE___CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "VITE_PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "VITE_TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "VITE_DFX_NETWORK": "local", "VITE_HOST": "http://localhost:8000" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.updateFavouriteTeam(favouriteTeamId);
      return result;
    } catch (error) {
      console.error("Error updating favourite team:", error);
      throw error;
    }
  }
  async function getProfile() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        { "DFX_VERSION": "0.14.4", "DFX_NETWORK": "local", "CANISTER_CANDID_PATH_OpenFPL_backend": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_OPENFPL_BACKEND": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_player_canister": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "CANISTER_CANDID_PATH_PLAYER_CANISTER": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_TOKEN_CANISTER": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_token_canister": "br5f7-7uaaa-aaaaa-qaaca-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_PLAYER_CANISTER": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_player_canister": "be2us-64aaa-aaaaa-qaabq-cai", "NNS_SNS_WASM_CANISTER_ID": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_NNS_SNS_WASM": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_nns_sns_wasm": "qaa6y-5yaaa-aaaaa-aaafa-cai", "NNS_ROOT_CANISTER_ID": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_NNS_ROOT": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_nns_root": "r7inp-6aaaa-aaaaa-aaabq-cai", "NNS_REGISTRY_CANISTER_ID": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_NNS_REGISTRY": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_nns_registry": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "NNS_LIFELINE_CANISTER_ID": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_NNS_LIFELINE": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_nns_lifeline": "rno2w-sqaaa-aaaaa-aaacq-cai", "NNS_LEDGER_CANISTER_ID": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_NNS_LEDGER": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_nns_ledger": "ryjl3-tyaaa-aaaaa-aaaba-cai", "NNS_GOVERNANCE_CANISTER_ID": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_NNS_GOVERNANCE": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_nns_governance": "rrkah-fqaaa-aaaaa-aaaaq-cai", "NNS_GENESIS_TOKEN_CANISTER_ID": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_NNS_GENESIS_TOKEN": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_nns_genesis_token": "renrk-eyaaa-aaaaa-aaada-cai", "NNS_CYCLES_MINTING_CANISTER_ID": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_NNS_CYCLES_MINTING": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_nns_cycles_minting": "rkp4c-7iaaa-aaaaa-aaaca-cai", "INTERNET_IDENTITY_CANISTER_ID": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_INTERNET_IDENTITY": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_internet_identity": "qhbym-qaaaa-aaaaa-aaafq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OPENFPL_FRONTEND": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OpenFPL_frontend": "bd3sg-teaaa-aaaaa-qaaba-cai", "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OPENFPL_BACKEND": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OpenFPL_backend": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_CANDID_PATH": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_frontend/assetstorage.did", "VITE_AUTH_PROVIDER_URL": "https://identity.ic0.app", "LESSOPEN": "| /usr/bin/lesspipe %s", "USER": "james", "npm_config_user_agent": "npm/9.5.0 node/v18.15.0 linux x64 workspaces/false", "GIT_ASKPASS": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass.sh", "npm_node_execpath": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "SHLVL": "1", "npm_config_noproxy": "", "HOME": "/home/james", "MOTD_SHOWN": "update-motd", "NVM_BIN": "/home/james/.nvm/versions/node/v18.15.0/bin", "TERM_PROGRAM_VERSION": "1.84.2", "VSCODE_IPC_HOOK_CLI": "/tmp/vscode-ipc-a6ec3a05-a494-491b-8658-e2826d0ed848.sock", "npm_package_json": "/home/james/OpenFPL/package.json", "NVM_INC": "/home/james/.nvm/versions/node/v18.15.0/include/node", "VSCODE_GIT_ASKPASS_MAIN": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass-main.js", "VSCODE_GIT_ASKPASS_NODE": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node", "npm_config_userconfig": "/home/james/.npmrc", "npm_config_local_prefix": "/home/james/OpenFPL", "COLORTERM": "truecolor", "WSL_DISTRO_NAME": "Ubuntu", "COLOR": "0", "NVM_DIR": "/home/james/.nvm", "npm_config_metrics_registry": "https://registry.npmjs.org/", "LOGNAME": "james", "NAME": "DESKTOP-UV8C3VI", "WSL_INTEROP": "/run/WSL/12_interop", "_": "/home/james/bin/dfx", "npm_config_prefix": "/home/james/.nvm/versions/node/v18.15.0", "TERM": "xterm-256color", "npm_config_cache": "/home/james/.npm", "npm_config_node_gyp": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", "PATH": "/home/james/OpenFPL/node_modules/.bin:/home/james/node_modules/.bin:/home/node_modules/.bin:/node_modules/.bin:/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/@npmcli/run-script/lib/node-gyp-bin:/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/remote-cli:/home/james/bin:/home/james/.nvm/versions/node/v18.15.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/Microsoft/jdk-11.0.16.101-hotspot/bin:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/bin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/libnvvp:/mnt/c/Program Files (x86)/Common Files/Intel/Shared Libraries/redist/intel64/compiler:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/Nsight Compute 2020.1.2/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Git LFS:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files (x86)/ZED SDK/dependencies/freeglut_2.8/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/glew-1.12.0/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/opencv_3.1.0/x64:/mnt/c/Program Files (x86)/ZED SDK/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/Scripts/:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/james/.dotnet/tools:/mnt/c/Users/james/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/heroku/bin:/mnt/c/Users/james/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin:/mnt/c/Program Files/MongoDB/Server/4.4/bin/:/mnt/c/Users/james/AppData/Roaming/npm:/mnt/c/Users/james/.dotnet/tools:/snap/bin", "NODE": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "npm_package_name": "open_fpl_frontend", "LANG": "C.UTF-8", "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:", "TERM_PROGRAM": "vscode", "VSCODE_GIT_IPC_HANDLE": "/tmp/vscode-git-ec8aec957c.sock", "npm_lifecycle_script": "vite build", "SHELL": "/bin/bash", "npm_package_version": "0.1.0", "npm_lifecycle_event": "build", "LESSCLOSE": "/usr/bin/lesspipe %s %s", "VSCODE_GIT_ASKPASS_EXTRA_ARGS": "", "npm_config_globalconfig": "/home/james/.nvm/versions/node/v18.15.0/etc/npmrc", "npm_config_init_module": "/home/james/.npm-init.js", "PWD": "/home/james/OpenFPL", "npm_execpath": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/bin/npm-cli.js", "NVM_CD_FLAGS": "", "XDG_DATA_DIRS": "/usr/local/share:/usr/share:/var/lib/snapd/desktop", "npm_config_global_prefix": "/home/james/.nvm/versions/node/v18.15.0", "npm_command": "run-script", "HOSTTYPE": "x86_64", "WSLENV": "VSCODE_WSL_EXT_LOCATION/up", "INIT_CWD": "/home/james/OpenFPL", "EDITOR": "vi", "NODE_ENV": "production", "VITE_OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "VITE_OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "VITE___CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "VITE_PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "VITE_TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "VITE_DFX_NETWORK": "local", "VITE_HOST": "http://localhost:8000" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.getProfileDTO();
      set(result);
      return result;
    } catch (error) {
      console.error("Error getting profile:", error);
      throw error;
    }
  }
  async function updateProfilePicture(picture) {
    try {
      const maxPictureSize = 1e3;
      if (picture.size > maxPictureSize * 1024) {
        return null;
      }
      const reader = new FileReader();
      reader.readAsArrayBuffer(picture);
      reader.onloadend = async () => {
        const arrayBuffer = reader.result;
        const uint8Array = new Uint8Array(arrayBuffer);
        try {
          const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            { "DFX_VERSION": "0.14.4", "DFX_NETWORK": "local", "CANISTER_CANDID_PATH_OpenFPL_backend": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_OPENFPL_BACKEND": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_backend/OpenFPL_backend.did", "CANISTER_CANDID_PATH_player_canister": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "CANISTER_CANDID_PATH_PLAYER_CANISTER": "/home/james/OpenFPL/.dfx/local/canisters/player_canister/player_canister.did", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_TOKEN_CANISTER": "br5f7-7uaaa-aaaaa-qaaca-cai", "CANISTER_ID_token_canister": "br5f7-7uaaa-aaaaa-qaaca-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_PLAYER_CANISTER": "be2us-64aaa-aaaaa-qaabq-cai", "CANISTER_ID_player_canister": "be2us-64aaa-aaaaa-qaabq-cai", "NNS_SNS_WASM_CANISTER_ID": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_NNS_SNS_WASM": "qaa6y-5yaaa-aaaaa-aaafa-cai", "CANISTER_ID_nns_sns_wasm": "qaa6y-5yaaa-aaaaa-aaafa-cai", "NNS_ROOT_CANISTER_ID": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_NNS_ROOT": "r7inp-6aaaa-aaaaa-aaabq-cai", "CANISTER_ID_nns_root": "r7inp-6aaaa-aaaaa-aaabq-cai", "NNS_REGISTRY_CANISTER_ID": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_NNS_REGISTRY": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "CANISTER_ID_nns_registry": "rwlgt-iiaaa-aaaaa-aaaaa-cai", "NNS_LIFELINE_CANISTER_ID": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_NNS_LIFELINE": "rno2w-sqaaa-aaaaa-aaacq-cai", "CANISTER_ID_nns_lifeline": "rno2w-sqaaa-aaaaa-aaacq-cai", "NNS_LEDGER_CANISTER_ID": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_NNS_LEDGER": "ryjl3-tyaaa-aaaaa-aaaba-cai", "CANISTER_ID_nns_ledger": "ryjl3-tyaaa-aaaaa-aaaba-cai", "NNS_GOVERNANCE_CANISTER_ID": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_NNS_GOVERNANCE": "rrkah-fqaaa-aaaaa-aaaaq-cai", "CANISTER_ID_nns_governance": "rrkah-fqaaa-aaaaa-aaaaq-cai", "NNS_GENESIS_TOKEN_CANISTER_ID": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_NNS_GENESIS_TOKEN": "renrk-eyaaa-aaaaa-aaada-cai", "CANISTER_ID_nns_genesis_token": "renrk-eyaaa-aaaaa-aaada-cai", "NNS_CYCLES_MINTING_CANISTER_ID": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_NNS_CYCLES_MINTING": "rkp4c-7iaaa-aaaaa-aaaca-cai", "CANISTER_ID_nns_cycles_minting": "rkp4c-7iaaa-aaaaa-aaaca-cai", "INTERNET_IDENTITY_CANISTER_ID": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_INTERNET_IDENTITY": "qhbym-qaaaa-aaaaa-aaafq-cai", "CANISTER_ID_internet_identity": "qhbym-qaaaa-aaaaa-aaafq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OPENFPL_FRONTEND": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_ID_OpenFPL_frontend": "bd3sg-teaaa-aaaaa-qaaba-cai", "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OPENFPL_BACKEND": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID_OpenFPL_backend": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "CANISTER_CANDID_PATH": "/home/james/OpenFPL/.dfx/local/canisters/OpenFPL_frontend/assetstorage.did", "VITE_AUTH_PROVIDER_URL": "https://identity.ic0.app", "LESSOPEN": "| /usr/bin/lesspipe %s", "USER": "james", "npm_config_user_agent": "npm/9.5.0 node/v18.15.0 linux x64 workspaces/false", "GIT_ASKPASS": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass.sh", "npm_node_execpath": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "SHLVL": "1", "npm_config_noproxy": "", "HOME": "/home/james", "MOTD_SHOWN": "update-motd", "NVM_BIN": "/home/james/.nvm/versions/node/v18.15.0/bin", "TERM_PROGRAM_VERSION": "1.84.2", "VSCODE_IPC_HOOK_CLI": "/tmp/vscode-ipc-a6ec3a05-a494-491b-8658-e2826d0ed848.sock", "npm_package_json": "/home/james/OpenFPL/package.json", "NVM_INC": "/home/james/.nvm/versions/node/v18.15.0/include/node", "VSCODE_GIT_ASKPASS_MAIN": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/extensions/git/dist/askpass-main.js", "VSCODE_GIT_ASKPASS_NODE": "/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/node", "npm_config_userconfig": "/home/james/.npmrc", "npm_config_local_prefix": "/home/james/OpenFPL", "COLORTERM": "truecolor", "WSL_DISTRO_NAME": "Ubuntu", "COLOR": "0", "NVM_DIR": "/home/james/.nvm", "npm_config_metrics_registry": "https://registry.npmjs.org/", "LOGNAME": "james", "NAME": "DESKTOP-UV8C3VI", "WSL_INTEROP": "/run/WSL/12_interop", "_": "/home/james/bin/dfx", "npm_config_prefix": "/home/james/.nvm/versions/node/v18.15.0", "TERM": "xterm-256color", "npm_config_cache": "/home/james/.npm", "npm_config_node_gyp": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js", "PATH": "/home/james/OpenFPL/node_modules/.bin:/home/james/node_modules/.bin:/home/node_modules/.bin:/node_modules/.bin:/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/node_modules/@npmcli/run-script/lib/node-gyp-bin:/home/james/.vscode-server/bin/1a5daa3a0231a0fbba4f14db7ec463cf99d7768e/bin/remote-cli:/home/james/bin:/home/james/.nvm/versions/node/v18.15.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/Microsoft/jdk-11.0.16.101-hotspot/bin:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Microsoft SDKs/Azure/CLI2/wbin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/bin:/mnt/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0/libnvvp:/mnt/c/Program Files (x86)/Common Files/Intel/Shared Libraries/redist/intel64/compiler:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Windows/System32/OpenSSH/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/Nsight Compute 2020.1.2/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Git LFS:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/ProgramData/DockerDesktop/version-bin:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files (x86)/ZED SDK/dependencies/freeglut_2.8/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/glew-1.12.0/x64:/mnt/c/Program Files (x86)/ZED SDK/dependencies/opencv_3.1.0/x64:/mnt/c/Program Files (x86)/ZED SDK/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/Scripts/:/mnt/c/Users/james/AppData/Local/Programs/Python/Python37/:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/james/.dotnet/tools:/mnt/c/Users/james/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Users/james/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/heroku/bin:/mnt/c/Users/james/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin:/mnt/c/Program Files/MongoDB/Server/4.4/bin/:/mnt/c/Users/james/AppData/Roaming/npm:/mnt/c/Users/james/.dotnet/tools:/snap/bin", "NODE": "/home/james/.nvm/versions/node/v18.15.0/bin/node", "npm_package_name": "open_fpl_frontend", "LANG": "C.UTF-8", "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:", "TERM_PROGRAM": "vscode", "VSCODE_GIT_IPC_HANDLE": "/tmp/vscode-git-ec8aec957c.sock", "npm_lifecycle_script": "vite build", "SHELL": "/bin/bash", "npm_package_version": "0.1.0", "npm_lifecycle_event": "build", "LESSCLOSE": "/usr/bin/lesspipe %s %s", "VSCODE_GIT_ASKPASS_EXTRA_ARGS": "", "npm_config_globalconfig": "/home/james/.nvm/versions/node/v18.15.0/etc/npmrc", "npm_config_init_module": "/home/james/.npm-init.js", "PWD": "/home/james/OpenFPL", "npm_execpath": "/home/james/.nvm/versions/node/v18.15.0/lib/node_modules/npm/bin/npm-cli.js", "NVM_CD_FLAGS": "", "XDG_DATA_DIRS": "/usr/local/share:/usr/share:/var/lib/snapd/desktop", "npm_config_global_prefix": "/home/james/.nvm/versions/node/v18.15.0", "npm_command": "run-script", "HOSTTYPE": "x86_64", "WSLENV": "VSCODE_WSL_EXT_LOCATION/up", "INIT_CWD": "/home/james/OpenFPL", "EDITOR": "vi", "NODE_ENV": "production", "VITE_OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "VITE_OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "VITE___CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "VITE_PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "VITE_TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "VITE_DFX_NETWORK": "local", "VITE_HOST": "http://localhost:8000" }.OPENFPL_BACKEND_CANISTER_ID ?? ""
          );
          const result = await identityActor.updateProfilePicture(uint8Array);
          return result;
        } catch (error) {
          console.error(error);
        }
      };
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }
  return {
    subscribe: subscribe2,
    updateUsername,
    updateFavouriteTeam,
    getProfile,
    updateProfilePicture
  };
}
const userStore = createUserStore();
const CopyIcon_svelte_svelte_type_style_lang = "";
const css$3 = {
  code: ".icon.svelte-1qbujws:hover{fill:var(--hover-color)}",
  map: null
};
const CopyIcon = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { className = "" } = $$props;
  let { principalId = "" } = $$props;
  let { onClick } = $$props;
  let { hoverColor = "red" } = $$props;
  if ($$props.className === void 0 && $$bindings.className && className !== void 0)
    $$bindings.className(className);
  if ($$props.principalId === void 0 && $$bindings.principalId && principalId !== void 0)
    $$bindings.principalId(principalId);
  if ($$props.onClick === void 0 && $$bindings.onClick && onClick !== void 0)
    $$bindings.onClick(onClick);
  if ($$props.hoverColor === void 0 && $$bindings.hoverColor && hoverColor !== void 0)
    $$bindings.hoverColor(hoverColor);
  $$result.css.add(css$3);
  return `<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="${escape(null_to_empty(className), true) + " svelte-1qbujws"}" fill="currentColor" viewBox="0 0 16 16" style="${"--hover-color: " + escape(hoverColor, true) + "; cursor: 'pointer'"}"><path d="M12.136.326A1.5 1.5 0 0 1 14 1.78V3h.5A1.5 1.5 0 0 1 16 4.5v9a1.5 1.5 0 0 1-1.5 1.5h-13A1.5 1.5 0 0 1 0 13.5v-9a1.5 1.5 0 0 1 1.432-1.499L12.136.326zM5.562 3H13V1.78a.5.5 0 0 0-.621-.484L5.562 3zM1.5 4a.5.5 0 0 0-.5.5v9a.5.5 0 0 0 .5.5h13a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-13z"></path><path d="M3.5 2a.5.5 0 0 0-.5.5v10a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5v-10a.5.5 0 0 0-.5-.5h-9zM2 2.5A1.5 1.5 0 0 1 3.5 1h9A1.5 1.5 0 0 1 14 2.5v10a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 12.5v-10zm9.5 3A1.5 1.5 0 0 1 13 7h1.5V3.5a1.5 1.5 0 0 0-1.5-1.5H9V4a1.5 1.5 0 0 1 1.5 1.5v1zm0 1a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1z"></path></svg>`;
});
const updateUsernameModal_svelte_svelte_type_style_lang = "";
const css$2 = {
  code: ".modal-backdrop.svelte-1fl295u{z-index:1000}",
  map: null
};
function isDisplayNameValid(displayName) {
  if (displayName.length < 3 || displayName.length > 20) {
    return false;
  }
  return /^[a-zA-Z0-9 ]+$/.test(displayName);
}
const Update_username_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let isSubmitDisabled;
  let { showModal } = $$props;
  let { closeModal } = $$props;
  let { cancelModal } = $$props;
  let { newUsername = "" } = $$props;
  let { isLoading } = $$props;
  if ($$props.showModal === void 0 && $$bindings.showModal && showModal !== void 0)
    $$bindings.showModal(showModal);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  if ($$props.cancelModal === void 0 && $$bindings.cancelModal && cancelModal !== void 0)
    $$bindings.cancelModal(cancelModal);
  if ($$props.newUsername === void 0 && $$bindings.newUsername && newUsername !== void 0)
    $$bindings.newUsername(newUsername);
  if ($$props.isLoading === void 0 && $$bindings.isLoading && isLoading !== void 0)
    $$bindings.isLoading(isLoading);
  $$result.css.add(css$2);
  isSubmitDisabled = !isDisplayNameValid(newUsername);
  return `${showModal ? `<div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop svelte-1fl295u"><div class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"><div class="mt-3 text-center"><h3 class="text-lg leading-6 font-medium mb-2">Update Display Name</h3>
        <form><div class="mt-4"><input type="text" class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black" placeholder="New Username"${add_attribute("value", newUsername, 0)}></div>
          <div class="items-center py-3 flex space-x-4"><button class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300">Cancel
            </button>
            <button class="${escape(null_to_empty(`px-4 py-2 ${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`), true) + " svelte-1fl295u"}" type="submit" ${isSubmitDisabled ? "disabled" : ""}>Use
            </button></div></form></div></div></div>` : ``}`;
});
const updateFavouriteTeamModal_svelte_svelte_type_style_lang = "";
const css$1 = {
  code: ".modal-backdrop.svelte-1fl295u{z-index:1000}",
  map: null
};
const Update_favourite_team_modal = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let { showModal } = $$props;
  let { closeModal } = $$props;
  let { cancelModal } = $$props;
  let { newFavouriteTeam = 0 } = $$props;
  let { isLoading } = $$props;
  let isSubmitDisabled = true;
  let teams;
  onDestroy(() => {
  });
  if ($$props.showModal === void 0 && $$bindings.showModal && showModal !== void 0)
    $$bindings.showModal(showModal);
  if ($$props.closeModal === void 0 && $$bindings.closeModal && closeModal !== void 0)
    $$bindings.closeModal(closeModal);
  if ($$props.cancelModal === void 0 && $$bindings.cancelModal && cancelModal !== void 0)
    $$bindings.cancelModal(cancelModal);
  if ($$props.newFavouriteTeam === void 0 && $$bindings.newFavouriteTeam && newFavouriteTeam !== void 0)
    $$bindings.newFavouriteTeam(newFavouriteTeam);
  if ($$props.isLoading === void 0 && $$bindings.isLoading && isLoading !== void 0)
    $$bindings.isLoading(isLoading);
  $$result.css.add(css$1);
  isSubmitDisabled = newFavouriteTeam <= 0;
  return `${showModal ? `<div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop svelte-1fl295u"><div class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"><div class="mt-3 text-center"><h3 class="text-lg leading-6 font-medium mb-2">Update Favourite Team
        </h3>
        <div class="w-full border border-gray-500 mt-4 mb-2"><select class="w-full p-2 rounded-md fpl-dropdown"><option${add_attribute("value", 0, 0)}>Select Team</option>${each(teams, (team) => {
    return `<option${add_attribute("value", team.id, 0)}>${escape(team.friendlyName)}</option>`;
  })}</select></div></div>

      <div class="bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-1 mt-4" role="alert"><p class="font-bold text-sm">Warning</p>
        <p class="font-bold text-xs">You can only set your favourite team once per season.
        </p></div>

      <div class="items-center py-3 flex space-x-4"><button class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300">Cancel
        </button>
        <button class="${escape(null_to_empty(`px-4 py-2 ${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`), true) + " svelte-1fl295u"}" ${isSubmitDisabled ? "disabled" : ""}>Use
        </button></div></div></div>` : ``}`;
});
const profileDetail_svelte_svelte_type_style_lang = "";
const css = {
  code: '.file-upload-wrapper.svelte-e6um5o{position:relative;overflow:hidden;display:inline-block;width:100%}.btn-file-upload.svelte-e6um5o{width:100%;border:none;padding:10px 20px;border-radius:5px;font-size:1em;cursor:pointer;text-align:center;display:block}input[type="file"].svelte-e6um5o{font-size:100px;position:absolute;left:0;top:0;opacity:0;width:100%;height:100%;cursor:pointer}',
  map: null
};
const Profile_detail = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  let $isLoading, $$unsubscribe_isLoading;
  let $profile, $$unsubscribe_profile;
  let $profileSrc, $$unsubscribe_profileSrc;
  let teams;
  let profile = writable(null);
  $$unsubscribe_profile = subscribe(profile, (value) => $profile = value);
  let profileSrc = writable("profile_placeholder.png");
  $$unsubscribe_profileSrc = subscribe(profileSrc, (value) => $profileSrc = value);
  let showUsernameModal = false;
  let showFavouriteTeamModal = false;
  let isLoading = writable(false);
  $$unsubscribe_isLoading = subscribe(isLoading, (value) => $isLoading = value);
  onDestroy(() => {
  });
  async function closeUsernameModal() {
    const profileData = await userStore.getProfile();
    profile.set(profileData);
    showUsernameModal = false;
  }
  function cancelUsernameModal() {
    showUsernameModal = false;
  }
  async function closeFavouriteTeamModal() {
    const profileData = await userStore.getProfile();
    profile.set(profileData);
    showFavouriteTeamModal = false;
  }
  function cancelFavouriteTeamModal() {
    showFavouriteTeamModal = false;
  }
  function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
      toastStore.show("Copied!", "success");
    });
  }
  $$result.css.add(css);
  $$unsubscribe_isLoading();
  $$unsubscribe_profile();
  $$unsubscribe_profileSrc();
  return `${$isLoading ? `${validate_component(LoadingIcon, "LoadingIcon").$$render($$result, {}, {}, {})}` : `${validate_component(Update_username_modal, "UpdateUsernameModal").$$render(
    $$result,
    {
      newUsername: $profile ? $profile.displayName : "",
      showModal: showUsernameModal,
      closeModal: closeUsernameModal,
      cancelModal: cancelUsernameModal,
      isLoading
    },
    {},
    {}
  )}
  ${validate_component(Update_favourite_team_modal, "UpdateFavouriteTeamModal").$$render(
    $$result,
    {
      newFavouriteTeam: $profile ? $profile.favouriteTeamId : 0,
      showModal: showFavouriteTeamModal,
      closeModal: closeFavouriteTeamModal,
      cancelModal: cancelFavouriteTeamModal,
      isLoading
    },
    {},
    {}
  )}
  <div class="container mx-auto p-4">${$profile ? `<div class="flex flex-wrap"><div class="w-full md:w-auto px-2 ml-4 md:ml-0"><div class="group"><img${add_attribute("src", $profileSrc, 0)} alt="Profile" class="w-48 md:w-80 mb-1 rounded-lg">

            <div class="file-upload-wrapper mt-4 svelte-e6um5o"><button class="btn-file-upload fpl-button svelte-e6um5o">Upload Photo</button>
              <input type="file" id="profile-image" accept="image/*" style="opacity: 0; position: absolute; left: 0; top: 0;" class="svelte-e6um5o"></div></div></div>

        <div class="w-full md:w-3/4 px-2 mb-4"><div class="ml-4 p-4 rounded-lg"><p class="text-xs mb-2">Display Name:</p>
            <h2 class="text-2xl font-bold mb-2">${escape($profile?.displayName)}</h2>
            <button class="p-2 px-4 rounded fpl-button">Update
            </button>
            <p class="text-xs mb-2 mt-4">Favourite Team:</p>
            <h2 class="text-2xl font-bold mb-2">${escape(teams.find((x) => x.id === $profile?.favouriteTeamId)?.friendlyName)}</h2>
            <button class="p-2 px-4 rounded fpl-button" ${""}>Update
            </button>

            <p class="text-xs mb-2 mt-4">Joined:</p>
            <h2 class="text-2xl font-bold mb-2">August 2023</h2>

            <p class="text-xs mb-2 mt-4">Principal:</p>
            <div class="flex items-center"><h2 class="text-xs font-bold">${escape($profile?.principalName)}</h2>
              ${validate_component(CopyIcon, "CopyIcon").$$render(
    $$result,
    {
      onClick: copyToClipboard,
      principalId: $profile?.principalName,
      className: "ml-2 w-4 h-4"
    },
    {},
    {}
  )}</div></div></div></div>` : ``}
    <div class="flex flex-wrap -mx-2 mt-4"><div class="w-full px-2 mb-4"><div class="mt-4 px-2"><div class="grid grid-cols-1 md:grid-cols-4 gap-4"><div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"><img src="ICPCoin.png" alt="ICP" class="h-12 w-12">
              <div class="ml-4"><p class="font-bold">ICP</p>
                <p>0.00 ICP</p></div></div>
            <div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"><img src="FPLCoin.png" alt="FPL" class="h-12 w-12">
              <div class="ml-4"><p class="font-bold">FPL</p>
                <p>0.00 FPL</p></div></div>
            <div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"><img src="ckBTCCoin.png" alt="ICP" class="h-12 w-12">
              <div class="ml-4"><p class="font-bold">ckBTC</p>
                <p>0.00 ckBTC</p></div></div>
            <div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700"><img src="ckETHCoin.png" alt="ICP" class="h-12 w-12">
              <div class="ml-4"><p class="font-bold">ckETH</p>
                <p>0.00 ckETH</p></div></div></div></div></div></div></div>`}`;
});
const Page = create_ssr_component(($$result, $$props, $$bindings, slots) => {
  return `${validate_component(Layout, "Layout").$$render($$result, {}, {}, {
    default: () => {
      return `<div class="m-4"><div class="bg-panel rounded-lg m-4"><ul class="flex rounded-lg bg-light-gray px-4 pt-2"><li${add_attribute("class", `mr-4 text-xs md:text-lg ${"active-tab"}`, 0)}><button${add_attribute("class", `p-2 ${"text-white"}`, 0)}>Details</button></li>
        <li${add_attribute("class", `mr-4 text-xs md:text-lg ${""}`, 0)}><button${add_attribute(
        "class",
        `p-2 ${"text-gray-400"}`,
        0
      )}>Gameweeks</button></li></ul>

      ${`${validate_component(Profile_detail, "ProfileDetail").$$render($$result, {}, {}, {})}`}</div></div>`;
    }
  })}`;
});
export {
  Page as default
};
