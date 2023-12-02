

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.f2462c44.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.42c5f1dc.js","_app/immutable/chunks/singletons.e655d5e5.js","_app/immutable/chunks/Layout.3f9368f3.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/team-store.583260fe.js","_app/immutable/chunks/fixture-store.880a736f.js","_app/immutable/chunks/player-store.f12f3662.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
