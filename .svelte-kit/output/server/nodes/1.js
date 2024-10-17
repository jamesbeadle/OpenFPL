

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.CeJAXD20.js","_app/immutable/chunks/index.DFpwFe7w.js","_app/immutable/chunks/vendor.DpnYzutl.js"];
export const stylesheets = ["_app/immutable/assets/index.BBtGfIc5.css"];
export const fonts = [];
