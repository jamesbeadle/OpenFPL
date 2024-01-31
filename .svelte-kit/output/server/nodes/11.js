

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.e7592f28.js","_app/immutable/chunks/index.7ae1e80c.js","_app/immutable/chunks/vendor.84d60f27.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
