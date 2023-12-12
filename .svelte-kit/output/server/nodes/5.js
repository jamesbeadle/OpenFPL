

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.e3881191.js","_app/immutable/chunks/index.c2c9717e.js","_app/immutable/chunks/vendor.afe08946.js"];
export const stylesheets = ["_app/immutable/assets/index.7ccd4a3f.css"];
export const fonts = [];
