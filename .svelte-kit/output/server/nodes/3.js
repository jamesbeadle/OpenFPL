

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.I4JKBIn6.js","_app/immutable/chunks/index.Gc3xS_jC.js","_app/immutable/chunks/vendor.7Vtj8Ad0.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
