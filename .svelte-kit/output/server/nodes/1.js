

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.e0435de1.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.f0f38284.js","_app/immutable/chunks/singletons.f40d3e23.js","_app/immutable/chunks/index.8caf67b2.js"];
export const stylesheets = [];
export const fonts = [];
