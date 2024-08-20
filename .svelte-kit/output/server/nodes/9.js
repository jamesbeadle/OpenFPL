

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.KDkCnSlY.js","_app/immutable/chunks/index.Zdq0OkUn.js","_app/immutable/chunks/vendor.TTUw1T_A.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
