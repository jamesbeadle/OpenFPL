

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.abde0312.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.609df4f6.js","_app/immutable/chunks/singletons.1e6ef3c9.js","_app/immutable/chunks/Layout.133d3dbe.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/player-store.8fae22f0.js","_app/immutable/chunks/fixture-store.6c78e237.js","_app/immutable/chunks/team-store.6fe81208.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js","_app/immutable/chunks/ShirtIcon.3da312bd.js"];
export const stylesheets = ["_app/immutable/assets/11.ff16016e.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
