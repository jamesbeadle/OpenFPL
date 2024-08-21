

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.nJLY0Wkv.js","_app/immutable/chunks/index.Rxai5QA1.js","_app/immutable/chunks/vendor.OYOS_pBX.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
