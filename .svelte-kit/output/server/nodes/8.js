

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.C5H4-nj6.js","_app/immutable/chunks/index.DTt2ITp_.js","_app/immutable/chunks/vendor.Cp0fY2wr.js"];
export const stylesheets = ["_app/immutable/assets/index.BBtGfIc5.css"];
export const fonts = [];
