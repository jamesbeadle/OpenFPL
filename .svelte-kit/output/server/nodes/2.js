

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.PzCuB9id.js","_app/immutable/chunks/index.m8JWHEPG.js","_app/immutable/chunks/vendor.56YePHjp.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
