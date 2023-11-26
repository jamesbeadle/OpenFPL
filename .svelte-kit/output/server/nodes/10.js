

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.24335e16.js","_app/immutable/chunks/index.dab0e011.js","_app/immutable/chunks/manager-gameweeks.0fc5ef05.js","_app/immutable/chunks/Layout.9d799e1b.js","_app/immutable/chunks/stores.1c99ebdd.js","_app/immutable/chunks/singletons.4559802b.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/LoadingIcon.c6bc274d.js"];
export const stylesheets = ["_app/immutable/assets/10.f774a8e5.css","_app/immutable/assets/Layout.e9874687.css","_app/immutable/assets/LoadingIcon.2aedc414.css"];
export const fonts = [];
