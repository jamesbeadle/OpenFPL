

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.BDCcJ0qn.js","_app/immutable/chunks/index.D9GMCFuj.js","_app/immutable/chunks/vendor.egwcexiT.js"];
export const stylesheets = ["_app/immutable/assets/index.CJCc5hpr.css"];
export const fonts = [];
