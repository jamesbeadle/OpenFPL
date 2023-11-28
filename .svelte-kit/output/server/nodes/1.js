

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.154e3a4c.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.46fe71ba.js","_app/immutable/chunks/singletons.095fe9e5.js","_app/immutable/chunks/index.8caf67b2.js"];
export const stylesheets = [];
export const fonts = [];
