

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6._bSiXc3C.js","_app/immutable/chunks/index.ElgDWN08.js","_app/immutable/chunks/vendor.vK-mjBL1.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
