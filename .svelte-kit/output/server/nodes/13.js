

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.25160fda.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.1cdf6852.js","_app/immutable/chunks/singletons.08cdb953.js","_app/immutable/chunks/stores.032342f2.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
