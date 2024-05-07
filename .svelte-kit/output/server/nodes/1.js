

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.cF2vNSzE.js","_app/immutable/chunks/index.R7CZTyFa.js","_app/immutable/chunks/vendor.WW9KjT63.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
