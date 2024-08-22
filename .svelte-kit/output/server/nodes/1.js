

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.8Y4oWYXz.js","_app/immutable/chunks/index.WUYkU5M6.js","_app/immutable/chunks/vendor.zNSaqJ3p.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
