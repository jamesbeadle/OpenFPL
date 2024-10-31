

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.DXDa38dB.js","_app/immutable/chunks/index.DFZxxAAQ.js","_app/immutable/chunks/vendor.Du7A120V.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
