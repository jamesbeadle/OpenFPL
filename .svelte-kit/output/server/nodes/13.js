

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.e8f50c49.js","_app/immutable/chunks/index.7fb8d1f9.js","_app/immutable/chunks/vendor.c4358ad6.js"];
export const stylesheets = ["_app/immutable/assets/index.87959933.css"];
export const fonts = [];
