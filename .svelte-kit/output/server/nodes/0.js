

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.C-djF-mJ.js","_app/immutable/chunks/index.DwX5I7HC.js","_app/immutable/chunks/vendor.EauaSV0L.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
