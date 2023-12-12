

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.b7906301.js","_app/immutable/chunks/index.c2c9717e.js","_app/immutable/chunks/vendor.afe08946.js"];
export const stylesheets = ["_app/immutable/assets/index.7ccd4a3f.css"];
export const fonts = [];
