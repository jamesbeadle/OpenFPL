

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.th5D0551.js","_app/immutable/chunks/index.JK4c3-Fp.js","_app/immutable/chunks/vendor.uQyj3Iln.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
