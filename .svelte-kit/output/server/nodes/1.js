

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.676bba9c.js","_app/immutable/chunks/index.9a5c8108.js","_app/immutable/chunks/vendor.44a0d7d0.js"];
export const stylesheets = ["_app/immutable/assets/index.5b660869.css"];
export const fonts = [];
