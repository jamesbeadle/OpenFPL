

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.DGJ8p1DW.js","_app/immutable/chunks/index.CBno4y7n.js","_app/immutable/chunks/vendor.DSVolzRZ.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
