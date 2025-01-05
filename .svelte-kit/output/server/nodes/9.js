

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.DPYsY0Mp.js","_app/immutable/chunks/index.D9GMCFuj.js","_app/immutable/chunks/vendor.egwcexiT.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
