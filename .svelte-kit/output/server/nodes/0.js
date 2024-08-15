

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.p4xWBxRR.js","_app/immutable/chunks/index.eaLArCFx.js","_app/immutable/chunks/vendor.qbE2CGIj.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
