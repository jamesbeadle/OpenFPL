

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.5f05c333.js","_app/immutable/chunks/index.5e54b20c.js","_app/immutable/chunks/vendor.c13babfe.js"];
export const stylesheets = ["_app/immutable/assets/index.bda5f1d2.css"];
export const fonts = [];
