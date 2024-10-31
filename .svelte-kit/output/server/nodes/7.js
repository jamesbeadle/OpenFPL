

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.C2ZOLOr8.js","_app/immutable/chunks/index.BsijAXLB.js","_app/immutable/chunks/vendor.CEUmIKGa.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
