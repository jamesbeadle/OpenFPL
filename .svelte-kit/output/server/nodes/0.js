

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.8fdf40ef.js","_app/immutable/chunks/index.703f9152.js","_app/immutable/chunks/vendor.344be197.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
