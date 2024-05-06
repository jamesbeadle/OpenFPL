

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.uODh5m0x.js","_app/immutable/chunks/index.fbedQ5Nw.js","_app/immutable/chunks/vendor.VR1BIeqi.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
