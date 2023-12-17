

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.0fe54101.js","_app/immutable/chunks/index.7632008c.js","_app/immutable/chunks/vendor.6e108832.js"];
export const stylesheets = ["_app/immutable/assets/index.8e2e37d7.css"];
export const fonts = [];
