

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.sW9m2rkh.js","_app/immutable/chunks/index.0lrT4t34.js","_app/immutable/chunks/vendor.tUl_rBds.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
