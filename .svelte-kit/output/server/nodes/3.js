

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.1b95b1e4.js","_app/immutable/chunks/index.518537fd.js","_app/immutable/chunks/vendor.1cf599bd.js"];
export const stylesheets = ["_app/immutable/assets/index.85ac9d40.css"];
export const fonts = [];
