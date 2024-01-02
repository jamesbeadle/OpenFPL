

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.9ecaf355.js","_app/immutable/chunks/index.1556fb4a.js","_app/immutable/chunks/vendor.baec6da2.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
