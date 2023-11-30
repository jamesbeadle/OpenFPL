

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.cd016121.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.f89c8fde.js","_app/immutable/chunks/singletons.fe993027.js","_app/immutable/chunks/index.8caf67b2.js"];
export const stylesheets = [];
export const fonts = [];
