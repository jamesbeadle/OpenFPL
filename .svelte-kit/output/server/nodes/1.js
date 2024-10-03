

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.BLUPpjfc.js","_app/immutable/chunks/index.ryWaOCUa.js","_app/immutable/chunks/vendor.DNuI_ar3.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
