

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.zH7uLjn3.js","_app/immutable/chunks/index.0lrT4t34.js","_app/immutable/chunks/vendor.tUl_rBds.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
