

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.Z1G58NV7.js","_app/immutable/chunks/index.K4INsLk8.js","_app/immutable/chunks/vendor.TJSgd7yP.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
