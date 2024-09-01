

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.3Bm3-57-.js","_app/immutable/chunks/index.3Es5vrsK.js","_app/immutable/chunks/vendor.17icStZm.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
