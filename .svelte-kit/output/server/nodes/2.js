

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.7ee54ef1.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.ca043cdb.js","_app/immutable/chunks/singletons.3dcb92f8.js","_app/immutable/chunks/stores.61650043.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/manager-store.2eabe04b.js","_app/immutable/chunks/team-store.b38566f6.js","_app/immutable/chunks/fixture-store.ad45d677.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/player-store.7033c4f0.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js"];
export const stylesheets = ["_app/immutable/assets/2.cc11644e.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
