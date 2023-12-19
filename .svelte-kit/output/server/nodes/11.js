

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.c3dc9d26.js","_app/immutable/chunks/index.a9cd1a95.js","_app/immutable/chunks/vendor.5c3c0d70.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
