

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.a490ed8c.js","_app/immutable/chunks/index.a016ad39.js","_app/immutable/chunks/vendor.83e291d7.js"];
export const stylesheets = ["_app/immutable/assets/index.63adc4ed.css"];
export const fonts = [];
