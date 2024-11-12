

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.D09T2Ki2.js","_app/immutable/chunks/index.DyS20r-B.js","_app/immutable/chunks/vendor.wG2KDTnY.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
