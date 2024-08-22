

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.wAFc10fY.js","_app/immutable/chunks/index.r78v0xtU.js","_app/immutable/chunks/vendor.4zodS1aL.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
