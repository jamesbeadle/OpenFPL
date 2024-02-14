

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.tt2nAzt_.js","_app/immutable/chunks/index.yVgzs-im.js","_app/immutable/chunks/vendor.9jxumFXr.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
