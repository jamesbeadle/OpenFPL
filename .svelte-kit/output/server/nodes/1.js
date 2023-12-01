

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.a859d615.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/stores.7e512e60.js","_app/immutable/chunks/singletons.41ced38e.js","_app/immutable/chunks/index.c203a7c8.js"];
export const stylesheets = [];
export const fonts = [];
