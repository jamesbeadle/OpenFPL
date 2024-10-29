

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.DTD5Gc-K.js","_app/immutable/chunks/index.DTt2ITp_.js","_app/immutable/chunks/vendor.Cp0fY2wr.js"];
export const stylesheets = ["_app/immutable/assets/index.BBtGfIc5.css"];
export const fonts = [];
