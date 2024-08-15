

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.TZsyp_9J.js","_app/immutable/chunks/index.sHeLRatT.js","_app/immutable/chunks/vendor.HsHQge2x.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
