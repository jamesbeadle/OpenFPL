

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.svj5qKgG.js","_app/immutable/chunks/index.1VcgY_w9.js","_app/immutable/chunks/vendor.rPvzQVjH.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
