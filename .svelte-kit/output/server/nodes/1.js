

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.421248aa.js","_app/immutable/chunks/index.7fcbe5f0.js","_app/immutable/chunks/vendor.6c5fdda1.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
