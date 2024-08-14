

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.jlzglT4Z.js","_app/immutable/chunks/index.4pftDUbO.js","_app/immutable/chunks/vendor.PZHkTRC7.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
