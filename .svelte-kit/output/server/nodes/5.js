

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.c0b95d69.js","_app/immutable/chunks/index.a9cd1a95.js","_app/immutable/chunks/vendor.5c3c0d70.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
