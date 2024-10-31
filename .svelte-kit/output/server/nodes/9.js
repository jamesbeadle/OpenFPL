

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.B6KrxEny.js","_app/immutable/chunks/index.DFZxxAAQ.js","_app/immutable/chunks/vendor.Du7A120V.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
