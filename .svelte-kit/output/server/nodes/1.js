

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.BzNv_-3k.js","_app/immutable/chunks/index.D_Feu3Gc.js","_app/immutable/chunks/vendor.D6wBz0PL.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
