

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.qGWvay-v.js","_app/immutable/chunks/index.rTZoIK3A.js","_app/immutable/chunks/vendor.GILRkgIM.js"];
export const stylesheets = ["_app/immutable/assets/index.T2MyJ15X.css"];
export const fonts = [];
