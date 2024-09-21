

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.u565PPbc.js","_app/immutable/chunks/index.5my0k2Hm.js","_app/immutable/chunks/vendor.xejZ6l8L.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
