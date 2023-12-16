

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.3c567b3c.js","_app/immutable/chunks/index.9f0003df.js","_app/immutable/chunks/vendor.2e93f72a.js"];
export const stylesheets = ["_app/immutable/assets/index.fa34df7c.css"];
export const fonts = [];
