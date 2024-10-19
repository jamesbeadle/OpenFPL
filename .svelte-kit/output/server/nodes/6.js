

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.M8s0x9yw.js","_app/immutable/chunks/index.Cr2czQZv.js","_app/immutable/chunks/vendor.C4wzBxk1.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
