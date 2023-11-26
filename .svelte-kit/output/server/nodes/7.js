

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.6b491ee3.js","_app/immutable/chunks/index.dab0e011.js","_app/immutable/chunks/Layout.9d799e1b.js","_app/immutable/chunks/stores.1c99ebdd.js","_app/immutable/chunks/singletons.4559802b.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/LoadingIcon.c6bc274d.js","_app/immutable/chunks/manager-gameweeks.0fc5ef05.js","_app/immutable/chunks/ManagerService.84376201.js","_app/immutable/chunks/BadgeIcon.1a82ba04.js"];
export const stylesheets = ["_app/immutable/assets/Layout.e9874687.css","_app/immutable/assets/LoadingIcon.2aedc414.css"];
export const fonts = [];
