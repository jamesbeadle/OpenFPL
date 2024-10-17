

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.8FCNkLF2.js","_app/immutable/chunks/index.DFpwFe7w.js","_app/immutable/chunks/vendor.DpnYzutl.js"];
export const stylesheets = ["_app/immutable/assets/index.BBtGfIc5.css"];
export const fonts = [];
