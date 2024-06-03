

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.eBlFrywp.js","_app/immutable/chunks/index.Pu3xh3fW.js","_app/immutable/chunks/vendor.IJfVQMVv.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
