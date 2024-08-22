

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.1EyI8ao8.js","_app/immutable/chunks/index.BRpR1_Hq.js","_app/immutable/chunks/vendor.BBdnrATY.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
