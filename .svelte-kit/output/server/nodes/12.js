

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.6OU3vOIJ.js","_app/immutable/chunks/index.M7rHGF45.js","_app/immutable/chunks/vendor.c3b8Egkg.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
