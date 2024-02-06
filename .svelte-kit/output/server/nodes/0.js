

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.M3jys_Eu.js","_app/immutable/chunks/index.woy_BgMu.js","_app/immutable/chunks/vendor.28hILJez.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
