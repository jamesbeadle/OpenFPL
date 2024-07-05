

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.y_d1lq0F.js","_app/immutable/chunks/index.XnuAnO2E.js","_app/immutable/chunks/vendor.PFno64BW.js"];
export const stylesheets = ["_app/immutable/assets/index.KveW6Omx.css"];
export const fonts = [];
