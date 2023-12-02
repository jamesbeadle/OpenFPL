

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.e18e7f22.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.133d3dbe.js","_app/immutable/chunks/singletons.1e6ef3c9.js","_app/immutable/chunks/stores.609df4f6.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/manager-gameweeks.18433350.js","_app/immutable/chunks/team-store.6fe81208.js","_app/immutable/chunks/manager-store.0a59abeb.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js"];
export const stylesheets = ["_app/immutable/assets/12.1aed53fb.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
