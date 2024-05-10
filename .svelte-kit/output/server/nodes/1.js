

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.KiTqKpA8.js","_app/immutable/chunks/index.wVOtZ4od.js","_app/immutable/chunks/vendor.0WKKziQh.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
