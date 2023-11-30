

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.ba6f2247.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.30e0e13a.js","_app/immutable/chunks/singletons.b497871b.js","_app/immutable/chunks/index.8caf67b2.js"];
export const stylesheets = [];
export const fonts = [];
