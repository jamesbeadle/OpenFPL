

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.8dadfb0f.js","_app/immutable/chunks/index.70c0e864.js","_app/immutable/chunks/vendor.fac29999.js"];
export const stylesheets = ["_app/immutable/assets/index.636c12c5.css"];
export const fonts = [];
