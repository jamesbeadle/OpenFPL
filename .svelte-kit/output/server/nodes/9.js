

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.D4hYgEEi.js","_app/immutable/chunks/index.D_Rlc-U6.js","_app/immutable/chunks/vendor.mBn_TWMO.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
