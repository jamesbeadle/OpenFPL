

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.c59bc391.js","_app/immutable/chunks/index.53df1ff1.js","_app/immutable/chunks/vendor.e9b4e184.js"];
export const stylesheets = ["_app/immutable/assets/index.87be7e40.css"];
export const fonts = [];
