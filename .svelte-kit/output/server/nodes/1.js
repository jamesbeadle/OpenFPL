

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.lFC7FJfI.js","_app/immutable/chunks/index.ltbeZL92.js","_app/immutable/chunks/vendor.PqoAZjCC.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
