

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.B2tFZwj6.js","_app/immutable/chunks/index.DyS20r-B.js","_app/immutable/chunks/vendor.wG2KDTnY.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
