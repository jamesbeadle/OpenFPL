

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.-dMwtVS2.js","_app/immutable/chunks/index.1VcgY_w9.js","_app/immutable/chunks/vendor.rPvzQVjH.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
