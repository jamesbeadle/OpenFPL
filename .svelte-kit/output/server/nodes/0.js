

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.k0aTDK0b.js","_app/immutable/chunks/index.KoNxD4TA.js","_app/immutable/chunks/vendor.FdqEdyuK.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
