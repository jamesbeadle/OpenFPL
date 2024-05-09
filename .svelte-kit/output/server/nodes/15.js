

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.1E4bqT3e.js","_app/immutable/chunks/index.jymFHv7P.js","_app/immutable/chunks/vendor.iAeSp4oO.js"];
export const stylesheets = ["_app/immutable/assets/index.J-R-LVDQ.css"];
export const fonts = [];
