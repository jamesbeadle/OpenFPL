

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.B4d2l5KU.js","_app/immutable/chunks/index.DFpwFe7w.js","_app/immutable/chunks/vendor.DpnYzutl.js"];
export const stylesheets = ["_app/immutable/assets/index.BBtGfIc5.css"];
export const fonts = [];
