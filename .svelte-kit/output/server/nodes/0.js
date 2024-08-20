

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.U-NgMBqC.js","_app/immutable/chunks/index.J3tzzVes.js","_app/immutable/chunks/vendor.Mg_vAtjd.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
