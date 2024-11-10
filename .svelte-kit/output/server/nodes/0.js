

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.17ir03rb.js","_app/immutable/chunks/index.DjquHYxb.js","_app/immutable/chunks/vendor.CWgSn_oz.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
