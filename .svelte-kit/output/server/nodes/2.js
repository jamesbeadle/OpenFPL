

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.CnNh60wr.js","_app/immutable/chunks/index.DTt2ITp_.js","_app/immutable/chunks/vendor.Cp0fY2wr.js"];
export const stylesheets = ["_app/immutable/assets/index.BBtGfIc5.css"];
export const fonts = [];
