

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.PgiZ9arj.js","_app/immutable/chunks/index.1VcgY_w9.js","_app/immutable/chunks/vendor.rPvzQVjH.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
