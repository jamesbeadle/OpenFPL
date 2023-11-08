

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.f8d51ac4.js","_app/immutable/chunks/index.6dba6488.js","_app/immutable/chunks/singletons.c1c58b8d.js"];
export const stylesheets = [];
export const fonts = [];
