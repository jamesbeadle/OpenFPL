

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.d178bee2.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/singletons.08cdb953.js","_app/immutable/chunks/stores.032342f2.js","_app/immutable/chunks/Layout.1cdf6852.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/manager-store.cdcb2749.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/manager-gameweeks.6a346841.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
