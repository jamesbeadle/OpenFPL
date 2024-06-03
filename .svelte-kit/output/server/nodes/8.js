

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8._u-_EGQc.js","_app/immutable/chunks/index.Pu3xh3fW.js","_app/immutable/chunks/vendor.IJfVQMVv.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
