

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.f719984c.js","_app/immutable/chunks/index.2f2fe72d.js","_app/immutable/chunks/vendor.1e5b4dca.js"];
export const stylesheets = ["_app/immutable/assets/index.b7aec314.css"];
export const fonts = [];
