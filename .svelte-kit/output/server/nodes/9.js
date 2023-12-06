

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.e1e95558.js","_app/immutable/chunks/index.7fb8d1f9.js","_app/immutable/chunks/vendor.c4358ad6.js"];
export const stylesheets = ["_app/immutable/assets/index.87959933.css"];
export const fonts = [];
