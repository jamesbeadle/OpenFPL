

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.CBdVhGl2.js","_app/immutable/chunks/index.I7Cv-gam.js","_app/immutable/chunks/vendor.B6xHTgLG.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
