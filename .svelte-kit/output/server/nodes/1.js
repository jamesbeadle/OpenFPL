

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.e14a4310.js","_app/immutable/chunks/index.dab0e011.js","_app/immutable/chunks/stores.1c99ebdd.js","_app/immutable/chunks/singletons.4559802b.js"];
export const stylesheets = [];
export const fonts = [];
