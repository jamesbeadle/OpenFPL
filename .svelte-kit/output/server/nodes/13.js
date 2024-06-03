

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13._SKBBMwI.js","_app/immutable/chunks/index.Pu3xh3fW.js","_app/immutable/chunks/vendor.IJfVQMVv.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
