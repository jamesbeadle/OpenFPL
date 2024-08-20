

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.XFs5np5L.js","_app/immutable/chunks/index.ypy9IQtV.js","_app/immutable/chunks/vendor.nqTTqMOY.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
