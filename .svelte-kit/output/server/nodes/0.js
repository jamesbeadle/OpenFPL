

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.mYWXdg_9.js","_app/immutable/chunks/index.aU2k6uz2.js","_app/immutable/chunks/vendor.9RYp4bvU.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
