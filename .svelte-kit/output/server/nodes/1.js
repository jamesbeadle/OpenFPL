

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.f49e0cf4.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.95126db5.js","_app/immutable/chunks/singletons.fdfa7ed0.js"];
export const stylesheets = [];
export const fonts = [];
