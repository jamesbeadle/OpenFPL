

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.444dace1.js","_app/immutable/chunks/index.e590a2b1.js","_app/immutable/chunks/stores.ed880ce1.js","_app/immutable/chunks/singletons.2158a4f8.js"];
export const stylesheets = [];
export const fonts = [];
