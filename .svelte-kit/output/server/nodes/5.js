

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.7Ufg_gPp.js","_app/immutable/chunks/index.jymFHv7P.js","_app/immutable/chunks/vendor.iAeSp4oO.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
