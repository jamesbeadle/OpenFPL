

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.6203ac23.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.61650043.js","_app/immutable/chunks/singletons.3dcb92f8.js"];
export const stylesheets = [];
export const fonts = [];
