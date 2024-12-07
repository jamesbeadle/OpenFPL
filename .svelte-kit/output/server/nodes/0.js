

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.BD7tmnW6.js","_app/immutable/chunks/index.BDjDeS1_.js","_app/immutable/chunks/vendor.C9rQejrz.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
