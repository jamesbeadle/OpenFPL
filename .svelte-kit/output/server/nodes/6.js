

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.EMPN_88l.js","_app/immutable/chunks/index.x6363Mcl.js","_app/immutable/chunks/vendor.IfJNlM71.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
