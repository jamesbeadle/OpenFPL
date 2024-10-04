

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.Bv1xHxiz.js","_app/immutable/chunks/index.BG1BOtU1.js","_app/immutable/chunks/vendor.1capJgBY.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
