

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.a7304603.js","_app/immutable/chunks/index.2002a9fc.js","_app/immutable/chunks/vendor.53617c6c.js"];
export const stylesheets = ["_app/immutable/assets/index.2462d728.css"];
export const fonts = [];
