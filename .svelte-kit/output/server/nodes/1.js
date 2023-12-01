

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.9ce7dcd9.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/stores.a9eccd55.js","_app/immutable/chunks/singletons.d0372d1c.js","_app/immutable/chunks/index.c203a7c8.js"];
export const stylesheets = [];
export const fonts = [];
