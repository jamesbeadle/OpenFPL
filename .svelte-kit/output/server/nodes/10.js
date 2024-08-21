

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.yIB-cZSj.js","_app/immutable/chunks/index.NJOqtmUC.js","_app/immutable/chunks/vendor.yzg6jjxu.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
