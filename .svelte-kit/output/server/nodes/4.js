

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.2e13c6c8.js","_app/immutable/chunks/index.0dbfeadd.js","_app/immutable/chunks/vendor.b8eb0217.js"];
export const stylesheets = ["_app/immutable/assets/index.4b91e4d9.css"];
export const fonts = [];
