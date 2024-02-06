

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.A7Kyyijg.js","_app/immutable/chunks/index.woy_BgMu.js","_app/immutable/chunks/vendor.28hILJez.js"];
export const stylesheets = ["_app/immutable/assets/index.USi8Uar5.css"];
export const fonts = [];
