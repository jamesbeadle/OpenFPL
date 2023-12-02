

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.e77d2eb7.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.133d3dbe.js","_app/immutable/chunks/singletons.1e6ef3c9.js","_app/immutable/chunks/stores.609df4f6.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/team-store.6fe81208.js","_app/immutable/chunks/fixture-store.6c78e237.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
