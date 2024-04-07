

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.kWnEnGt-.js","_app/immutable/chunks/index.nxe-6-_U.js","_app/immutable/chunks/vendor.u30FvZHK.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
