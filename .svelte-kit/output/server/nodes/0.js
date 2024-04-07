

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.w3r0r4R7.js","_app/immutable/chunks/index.Kzc8PEeV.js","_app/immutable/chunks/vendor.w4HYmK7F.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
