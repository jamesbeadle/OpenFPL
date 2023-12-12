

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.46843984.js","_app/immutable/chunks/index.518537fd.js","_app/immutable/chunks/vendor.1cf599bd.js"];
export const stylesheets = ["_app/immutable/assets/index.85ac9d40.css"];
export const fonts = [];
