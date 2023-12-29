

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.4a8f7a8b.js","_app/immutable/chunks/index.d2fad0ed.js","_app/immutable/chunks/vendor.69eaddaa.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
