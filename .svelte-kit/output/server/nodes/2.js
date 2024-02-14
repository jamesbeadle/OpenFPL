

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.2fBg2P-G.js","_app/immutable/chunks/index.x6363Mcl.js","_app/immutable/chunks/vendor.IfJNlM71.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
