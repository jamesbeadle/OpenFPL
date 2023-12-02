

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.1b3752dd.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.609df4f6.js","_app/immutable/chunks/singletons.1e6ef3c9.js"];
export const stylesheets = [];
export const fonts = [];
