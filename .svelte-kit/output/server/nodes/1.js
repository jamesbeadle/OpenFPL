

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.81a707ff.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.fa259919.js","_app/immutable/chunks/singletons.7a3c8e4c.js"];
export const stylesheets = [];
export const fonts = [];
