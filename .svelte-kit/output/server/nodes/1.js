

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.9MAoFBVR.js","_app/immutable/chunks/index.2rImChHa.js","_app/immutable/chunks/vendor.e6fgO4QA.js"];
export const stylesheets = ["_app/immutable/assets/index.qr_rPNh4.css"];
export const fonts = [];
