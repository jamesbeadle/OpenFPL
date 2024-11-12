

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.CXKnbTf3.js","_app/immutable/chunks/index.SeitwhCX.js","_app/immutable/chunks/vendor.DZy5MdfI.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
