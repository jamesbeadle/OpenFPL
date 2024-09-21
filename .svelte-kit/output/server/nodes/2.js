

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.b5O1Splg.js","_app/immutable/chunks/index.5my0k2Hm.js","_app/immutable/chunks/vendor.xejZ6l8L.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
