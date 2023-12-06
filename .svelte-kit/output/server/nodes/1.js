

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.bacb42e1.js","_app/immutable/chunks/index.5cf108f4.js","_app/immutable/chunks/vendor.c5eb9305.js"];
export const stylesheets = ["_app/immutable/assets/index.90c185b1.css"];
export const fonts = [];
