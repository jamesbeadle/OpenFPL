

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.LK7o2BF1.js","_app/immutable/chunks/index.QuoSrVL_.js","_app/immutable/chunks/vendor.0WLB2fgp.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
