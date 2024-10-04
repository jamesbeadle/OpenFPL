

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.Cpy6N-Xc.js","_app/immutable/chunks/index.BG1BOtU1.js","_app/immutable/chunks/vendor.1capJgBY.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
