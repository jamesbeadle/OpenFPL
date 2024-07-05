

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.WtbHhTI8.js","_app/immutable/chunks/index.XnuAnO2E.js","_app/immutable/chunks/vendor.PFno64BW.js"];
export const stylesheets = ["_app/immutable/assets/index.KveW6Omx.css"];
export const fonts = [];
