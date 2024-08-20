

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.pEmgHQkH.js","_app/immutable/chunks/index.JK4c3-Fp.js","_app/immutable/chunks/vendor.uQyj3Iln.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
