

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.DMNRmVEQ.js","_app/immutable/chunks/index.DyS20r-B.js","_app/immutable/chunks/vendor.wG2KDTnY.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
