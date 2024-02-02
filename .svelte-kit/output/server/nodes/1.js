

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.cceec22c.js","_app/immutable/chunks/index.e30514c6.js","_app/immutable/chunks/vendor.3c23d1be.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
