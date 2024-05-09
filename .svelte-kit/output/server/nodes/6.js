

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.hRqvLUx8.js","_app/immutable/chunks/index.jymFHv7P.js","_app/immutable/chunks/vendor.iAeSp4oO.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
