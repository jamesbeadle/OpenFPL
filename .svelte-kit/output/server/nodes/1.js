

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1._tnVwQCa.js","_app/immutable/chunks/index.0lrT4t34.js","_app/immutable/chunks/vendor.tUl_rBds.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
