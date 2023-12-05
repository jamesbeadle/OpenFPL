

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.aa11f0d1.js","_app/immutable/chunks/index.2002a9fc.js","_app/immutable/chunks/vendor.53617c6c.js"];
export const stylesheets = ["_app/immutable/assets/index.2462d728.css"];
export const fonts = [];
