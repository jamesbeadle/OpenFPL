

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.8QfhJSs1.js","_app/immutable/chunks/index.BZGYu6nJ.js","_app/immutable/chunks/vendor.17mBzHWC.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
