

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.96406c2a.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.032342f2.js","_app/immutable/chunks/singletons.08cdb953.js"];
export const stylesheets = [];
export const fonts = [];
