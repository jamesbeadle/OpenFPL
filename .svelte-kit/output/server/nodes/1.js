

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.fcd8a0c8.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.193d467e.js","_app/immutable/chunks/singletons.20852139.js","_app/immutable/chunks/index.8caf67b2.js"];
export const stylesheets = [];
export const fonts = [];
