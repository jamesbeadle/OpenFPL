

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.SrgXE7Ro.js","_app/immutable/chunks/index.aU2k6uz2.js","_app/immutable/chunks/vendor.9RYp4bvU.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
