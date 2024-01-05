

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.49f08186.js","_app/immutable/chunks/index.ec0bc7a2.js","_app/immutable/chunks/vendor.c8bd3163.js"];
export const stylesheets = ["_app/immutable/assets/index.87be7e40.css"];
export const fonts = [];
