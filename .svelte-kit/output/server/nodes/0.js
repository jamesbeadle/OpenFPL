

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.f241e203.js","_app/immutable/chunks/index.518537fd.js","_app/immutable/chunks/vendor.1cf599bd.js"];
export const stylesheets = ["_app/immutable/assets/index.85ac9d40.css"];
export const fonts = [];
