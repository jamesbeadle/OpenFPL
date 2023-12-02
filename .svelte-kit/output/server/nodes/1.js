

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.a5b0366c.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.68a73d15.js","_app/immutable/chunks/singletons.94507497.js"];
export const stylesheets = [];
export const fonts = [];
