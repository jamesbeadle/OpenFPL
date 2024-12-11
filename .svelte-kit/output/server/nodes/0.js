

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.ChTgYgjT.js","_app/immutable/chunks/index.qOBDyYy7.js","_app/immutable/chunks/vendor.yqUud6LC.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
