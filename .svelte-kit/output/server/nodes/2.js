

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.2e5e4c0a.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.133d3dbe.js","_app/immutable/chunks/singletons.1e6ef3c9.js","_app/immutable/chunks/stores.609df4f6.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/manager-store.0a59abeb.js","_app/immutable/chunks/team-store.6fe81208.js","_app/immutable/chunks/fixture-store.6c78e237.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/player-store.8fae22f0.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js"];
export const stylesheets = ["_app/immutable/assets/2.cc11644e.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
