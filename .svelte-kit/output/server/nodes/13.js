

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.cUg3ANwh.js","_app/immutable/chunks/index.x6363Mcl.js","_app/immutable/chunks/vendor.IfJNlM71.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
