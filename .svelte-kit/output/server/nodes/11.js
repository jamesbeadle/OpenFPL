

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/logs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.93mOiYAF.js","_app/immutable/chunks/index.K4INsLk8.js","_app/immutable/chunks/vendor.TJSgd7yP.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
