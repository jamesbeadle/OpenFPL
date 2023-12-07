

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.510e99aa.js","_app/immutable/chunks/index.ae36a6ca.js","_app/immutable/chunks/vendor.2b865f86.js"];
export const stylesheets = ["_app/immutable/assets/index.e6470837.css"];
export const fonts = [];
