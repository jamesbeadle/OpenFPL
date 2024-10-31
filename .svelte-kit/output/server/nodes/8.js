

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.B9XtlVv7.js","_app/immutable/chunks/index.BsijAXLB.js","_app/immutable/chunks/vendor.CEUmIKGa.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
