

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.yY4ArU7b.js","_app/immutable/chunks/index.8_LEekar.js","_app/immutable/chunks/vendor.VJtSa6Jw.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
