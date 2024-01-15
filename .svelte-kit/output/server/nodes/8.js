

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.7cdb8cc9.js","_app/immutable/chunks/index.0e6051ce.js","_app/immutable/chunks/vendor.009d5c1c.js"];
export const stylesheets = ["_app/immutable/assets/index.4b91e4d9.css"];
export const fonts = [];
