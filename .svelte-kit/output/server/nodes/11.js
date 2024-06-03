

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/logs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.NMz2wqsC.js","_app/immutable/chunks/index.Pu3xh3fW.js","_app/immutable/chunks/vendor.IJfVQMVv.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
