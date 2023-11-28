

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.af8a0ab9.js","_app/immutable/chunks/index.85206748.js","_app/immutable/chunks/stores.8ae7c18f.js","_app/immutable/chunks/singletons.06434e25.js","_app/immutable/chunks/index.b378d913.js"];
export const stylesheets = [];
export const fonts = [];
