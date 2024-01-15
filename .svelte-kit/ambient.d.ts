
// this file is generated — do not edit it


/// <reference types="@sveltejs/kit" />

/**
 * Environment variables [loaded by Vite](https://vitejs.dev/guide/env-and-mode.html#env-files) from `.env` files and `process.env`. Like [`$env/dynamic/private`](https://kit.svelte.dev/docs/modules#$env-dynamic-private), this module cannot be imported into client-side code. This module only includes variables that _do not_ begin with [`config.kit.env.publicPrefix`](https://kit.svelte.dev/docs/configuration#env) _and do_ start with [`config.kit.env.privatePrefix`](https://kit.svelte.dev/docs/configuration#env) (if configured).
 * 
 * _Unlike_ [`$env/dynamic/private`](https://kit.svelte.dev/docs/modules#$env-dynamic-private), the values exported from this module are statically injected into your bundle at build time, enabling optimisations like dead code elimination.
 * 
 * ```ts
 * import { API_KEY } from '$env/static/private';
 * ```
 * 
 * Note that all environment variables referenced in your code should be declared (for example in an `.env` file), even if they don't have a value until the app is deployed:
 * 
 * ```
 * MY_FEATURE_FLAG=""
 * ```
 * 
 * You can override `.env` values from the command line like so:
 * 
 * ```bash
 * MY_FEATURE_FLAG="enabled" npm run dev
 * ```
 */
declare module '$env/static/private' {
	export const DFX_VERSION: string;
	export const DFX_NETWORK: string;
	export const CANISTER_CANDID_PATH_OpenFPL_backend: string;
	export const CANISTER_CANDID_PATH_OPENFPL_BACKEND: string;
	export const TOKEN_CANISTER_CANISTER_ID: string;
	export const CANISTER_ID_TOKEN_CANISTER: string;
	export const CANISTER_ID_token_canister: string;
	export const INTERNET_IDENTITY_CANISTER_ID: string;
	export const CANISTER_ID_INTERNET_IDENTITY: string;
	export const CANISTER_ID_internet_identity: string;
	export const OPENFPL_FRONTEND_CANISTER_ID: string;
	export const CANISTER_ID_OPENFPL_FRONTEND: string;
	export const CANISTER_ID_OpenFPL_frontend: string;
	export const OPENFPL_BACKEND_CANISTER_ID: string;
	export const CANISTER_ID_OPENFPL_BACKEND: string;
	export const CANISTER_ID_OpenFPL_backend: string;
	export const CANISTER_ID: string;
	export const CANISTER_CANDID_PATH: string;
	export const VITE_AUTH_PROVIDER_URL: string;
	export const LESSOPEN: string;
	export const USER: string;
	export const npm_config_user_agent: string;
	export const ARCHIVE_CONTROLLER: string;
	export const GIT_ASKPASS: string;
	export const npm_node_execpath: string;
	export const SHLVL: string;
	export const npm_config_noproxy: string;
	export const MOTD_SHOWN: string;
	export const HOME: string;
	export const TERM_PROGRAM_VERSION: string;
	export const TOKEN_NAME: string;
	export const MINTER_PRINCIPAL: string;
	export const NVM_BIN: string;
	export const VSCODE_IPC_HOOK_CLI: string;
	export const npm_package_json: string;
	export const NVM_INC: string;
	export const NETWORK: string;
	export const VSCODE_GIT_ASKPASS_MAIN: string;
	export const VSCODE_GIT_ASKPASS_NODE: string;
	export const npm_config_userconfig: string;
	export const npm_config_local_prefix: string;
	export const COLORTERM: string;
	export const WSL_DISTRO_NAME: string;
	export const COLOR: string;
	export const NVM_DIR: string;
	export const LOGNAME: string;
	export const NAME: string;
	export const WSL_INTEROP: string;
	export const _: string;
	export const npm_config_prefix: string;
	export const npm_config_npm_version: string;
	export const TERM: string;
	export const npm_config_cache: string;
	export const npm_config_node_gyp: string;
	export const PATH: string;
	export const NODE: string;
	export const npm_package_name: string;
	export const LANG: string;
	export const LS_COLORS: string;
	export const VSCODE_GIT_IPC_HANDLE: string;
	export const TERM_PROGRAM: string;
	export const npm_lifecycle_script: string;
	export const SHELL: string;
	export const npm_package_version: string;
	export const npm_lifecycle_event: string;
	export const LESSCLOSE: string;
	export const TOKEN_SYMBOL: string;
	export const VSCODE_GIT_ASKPASS_EXTRA_ARGS: string;
	export const npm_config_globalconfig: string;
	export const npm_config_init_module: string;
	export const PWD: string;
	export const npm_execpath: string;
	export const NVM_CD_FLAGS: string;
	export const XDG_DATA_DIRS: string;
	export const npm_config_global_prefix: string;
	export const npm_command: string;
	export const HOSTTYPE: string;
	export const WSLENV: string;
	export const INIT_CWD: string;
	export const EDITOR: string;
	export const NODE_ENV: string;
	export const VITE_OPENFPL_BACKEND_CANISTER_ID: string;
	export const VITE_OPENFPL_FRONTEND_CANISTER_ID: string;
	export const VITE___CANDID_UI_CANISTER_ID: string;
	export const VITE_TOKEN_CANISTER_CANISTER_ID: string;
}

/**
 * Similar to [`$env/static/private`](https://kit.svelte.dev/docs/modules#$env-static-private), except that it only includes environment variables that begin with [`config.kit.env.publicPrefix`](https://kit.svelte.dev/docs/configuration#env) (which defaults to `PUBLIC_`), and can therefore safely be exposed to client-side code.
 * 
 * Values are replaced statically at build time.
 * 
 * ```ts
 * import { PUBLIC_BASE_URL } from '$env/static/public';
 * ```
 */
declare module '$env/static/public' {
	
}

/**
 * This module provides access to runtime environment variables, as defined by the platform you're running on. For example if you're using [`adapter-node`](https://github.com/sveltejs/kit/tree/master/packages/adapter-node) (or running [`vite preview`](https://kit.svelte.dev/docs/cli)), this is equivalent to `process.env`. This module only includes variables that _do not_ begin with [`config.kit.env.publicPrefix`](https://kit.svelte.dev/docs/configuration#env) _and do_ start with [`config.kit.env.privatePrefix`](https://kit.svelte.dev/docs/configuration#env) (if configured).
 * 
 * This module cannot be imported into client-side code.
 * 
 * ```ts
 * import { env } from '$env/dynamic/private';
 * console.log(env.DEPLOYMENT_SPECIFIC_VARIABLE);
 * ```
 * 
 * > In `dev`, `$env/dynamic` always includes environment variables from `.env`. In `prod`, this behavior will depend on your adapter.
 */
declare module '$env/dynamic/private' {
	export const env: {
		DFX_VERSION: string;
		DFX_NETWORK: string;
		CANISTER_CANDID_PATH_OpenFPL_backend: string;
		CANISTER_CANDID_PATH_OPENFPL_BACKEND: string;
		TOKEN_CANISTER_CANISTER_ID: string;
		CANISTER_ID_TOKEN_CANISTER: string;
		CANISTER_ID_token_canister: string;
		INTERNET_IDENTITY_CANISTER_ID: string;
		CANISTER_ID_INTERNET_IDENTITY: string;
		CANISTER_ID_internet_identity: string;
		OPENFPL_FRONTEND_CANISTER_ID: string;
		CANISTER_ID_OPENFPL_FRONTEND: string;
		CANISTER_ID_OpenFPL_frontend: string;
		OPENFPL_BACKEND_CANISTER_ID: string;
		CANISTER_ID_OPENFPL_BACKEND: string;
		CANISTER_ID_OpenFPL_backend: string;
		CANISTER_ID: string;
		CANISTER_CANDID_PATH: string;
		VITE_AUTH_PROVIDER_URL: string;
		LESSOPEN: string;
		USER: string;
		npm_config_user_agent: string;
		ARCHIVE_CONTROLLER: string;
		GIT_ASKPASS: string;
		npm_node_execpath: string;
		SHLVL: string;
		npm_config_noproxy: string;
		MOTD_SHOWN: string;
		HOME: string;
		TERM_PROGRAM_VERSION: string;
		TOKEN_NAME: string;
		MINTER_PRINCIPAL: string;
		NVM_BIN: string;
		VSCODE_IPC_HOOK_CLI: string;
		npm_package_json: string;
		NVM_INC: string;
		NETWORK: string;
		VSCODE_GIT_ASKPASS_MAIN: string;
		VSCODE_GIT_ASKPASS_NODE: string;
		npm_config_userconfig: string;
		npm_config_local_prefix: string;
		COLORTERM: string;
		WSL_DISTRO_NAME: string;
		COLOR: string;
		NVM_DIR: string;
		LOGNAME: string;
		NAME: string;
		WSL_INTEROP: string;
		_: string;
		npm_config_prefix: string;
		npm_config_npm_version: string;
		TERM: string;
		npm_config_cache: string;
		npm_config_node_gyp: string;
		PATH: string;
		NODE: string;
		npm_package_name: string;
		LANG: string;
		LS_COLORS: string;
		VSCODE_GIT_IPC_HANDLE: string;
		TERM_PROGRAM: string;
		npm_lifecycle_script: string;
		SHELL: string;
		npm_package_version: string;
		npm_lifecycle_event: string;
		LESSCLOSE: string;
		TOKEN_SYMBOL: string;
		VSCODE_GIT_ASKPASS_EXTRA_ARGS: string;
		npm_config_globalconfig: string;
		npm_config_init_module: string;
		PWD: string;
		npm_execpath: string;
		NVM_CD_FLAGS: string;
		XDG_DATA_DIRS: string;
		npm_config_global_prefix: string;
		npm_command: string;
		HOSTTYPE: string;
		WSLENV: string;
		INIT_CWD: string;
		EDITOR: string;
		NODE_ENV: string;
		VITE_OPENFPL_BACKEND_CANISTER_ID: string;
		VITE_OPENFPL_FRONTEND_CANISTER_ID: string;
		VITE___CANDID_UI_CANISTER_ID: string;
		VITE_TOKEN_CANISTER_CANISTER_ID: string;
		[key: `PUBLIC_${string}`]: undefined;
		[key: `${string}`]: string | undefined;
	}
}

/**
 * Similar to [`$env/dynamic/private`](https://kit.svelte.dev/docs/modules#$env-dynamic-private), but only includes variables that begin with [`config.kit.env.publicPrefix`](https://kit.svelte.dev/docs/configuration#env) (which defaults to `PUBLIC_`), and can therefore safely be exposed to client-side code.
 * 
 * Note that public dynamic environment variables must all be sent from the server to the client, causing larger network requests — when possible, use `$env/static/public` instead.
 * 
 * ```ts
 * import { env } from '$env/dynamic/public';
 * console.log(env.PUBLIC_DEPLOYMENT_SPECIFIC_VARIABLE);
 * ```
 */
declare module '$env/dynamic/public' {
	export const env: {
		[key: `PUBLIC_${string}`]: string | undefined;
	}
}
