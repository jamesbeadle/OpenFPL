

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.BRb95a3E.js","_app/immutable/chunks/index.CtMgl_NB.js","_app/immutable/chunks/vendor.D7hZaGI6.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
