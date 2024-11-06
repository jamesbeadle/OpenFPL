

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.DTqmhGdB.js","_app/immutable/chunks/index.D_Rlc-U6.js","_app/immutable/chunks/vendor.mBn_TWMO.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
