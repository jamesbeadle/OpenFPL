

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.6VdPJE9K.js","_app/immutable/chunks/index.1VcgY_w9.js","_app/immutable/chunks/vendor.rPvzQVjH.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
