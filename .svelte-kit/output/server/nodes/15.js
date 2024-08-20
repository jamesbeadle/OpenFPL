

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.2dVGkb8d.js","_app/immutable/chunks/index.J3tzzVes.js","_app/immutable/chunks/vendor.Mg_vAtjd.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
