

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.fa045ff6.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.61650043.js","_app/immutable/chunks/singletons.3dcb92f8.js","_app/immutable/chunks/Layout.ca043cdb.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/team-store.b38566f6.js","_app/immutable/chunks/fixture-store.ad45d677.js","_app/immutable/chunks/player-store.7033c4f0.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
