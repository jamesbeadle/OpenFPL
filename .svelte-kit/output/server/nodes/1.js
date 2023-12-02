

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.c3156cfc.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.42c5f1dc.js","_app/immutable/chunks/singletons.e655d5e5.js"];
export const stylesheets = [];
export const fonts = [];
