

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.0742afd2.js","_app/immutable/chunks/index.5e54b20c.js","_app/immutable/chunks/vendor.c13babfe.js"];
export const stylesheets = ["_app/immutable/assets/index.bda5f1d2.css"];
export const fonts = [];
