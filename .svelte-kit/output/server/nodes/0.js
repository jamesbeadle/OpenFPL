

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.ffb1d7f6.js","_app/immutable/chunks/index.2b3b4d26.js","_app/immutable/chunks/vendor.112b4cf9.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
