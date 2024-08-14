

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.04c7nuK-.js","_app/immutable/chunks/index.8B52ealf.js","_app/immutable/chunks/vendor.9t0CBOOp.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
