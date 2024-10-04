

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.BVoxIxxJ.js","_app/immutable/chunks/index.CBno4y7n.js","_app/immutable/chunks/vendor.DSVolzRZ.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
