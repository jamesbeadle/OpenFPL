

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.CtrKm2WT.js","_app/immutable/chunks/index.L6XScnLJ.js","_app/immutable/chunks/vendor.xOyXnCjV.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
