

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.64438513.js","_app/immutable/chunks/index.1caa8ee0.js","_app/immutable/chunks/vendor.c859d4b1.js"];
export const stylesheets = ["_app/immutable/assets/index.c143d844.css"];
export const fonts = [];
