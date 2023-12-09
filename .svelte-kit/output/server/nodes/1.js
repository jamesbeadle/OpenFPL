

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.9470c4ff.js","_app/immutable/chunks/index.70c0e864.js","_app/immutable/chunks/vendor.fac29999.js"];
export const stylesheets = ["_app/immutable/assets/index.636c12c5.css"];
export const fonts = [];
