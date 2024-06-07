

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.Xlvy9yfh.js","_app/immutable/chunks/index.a29C8zV4.js","_app/immutable/chunks/vendor.4IjpAYxE.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
