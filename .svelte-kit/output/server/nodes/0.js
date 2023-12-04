

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.ae1bd9e4.js","_app/immutable/chunks/index.f6aa8908.js","_app/immutable/chunks/vendor.0a97e0bc.js"];
export const stylesheets = ["_app/immutable/assets/index.99ad048d.css"];
export const fonts = [];
