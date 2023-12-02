

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.06798dd9.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.fa259919.js","_app/immutable/chunks/singletons.7a3c8e4c.js","_app/immutable/chunks/Layout.37f8df07.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/player-store.8a60313a.js","_app/immutable/chunks/fixture-store.5d9e8d18.js","_app/immutable/chunks/team-store.2ca3943b.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js","_app/immutable/chunks/ShirtIcon.3da312bd.js"];
export const stylesheets = ["_app/immutable/assets/11.ff16016e.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
