

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.D5tZYd_p.js","_app/immutable/chunks/index.DTt2ITp_.js","_app/immutable/chunks/vendor.Cp0fY2wr.js"];
export const stylesheets = ["_app/immutable/assets/index.BBtGfIc5.css"];
export const fonts = [];
