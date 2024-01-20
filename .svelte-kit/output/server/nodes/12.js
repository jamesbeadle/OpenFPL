

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.2799d37f.js","_app/immutable/chunks/index.5e54b20c.js","_app/immutable/chunks/vendor.c13babfe.js"];
export const stylesheets = ["_app/immutable/assets/index.bda5f1d2.css"];
export const fonts = [];
