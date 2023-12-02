

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.1bfacfde.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.ca043cdb.js","_app/immutable/chunks/singletons.3dcb92f8.js","_app/immutable/chunks/stores.61650043.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
