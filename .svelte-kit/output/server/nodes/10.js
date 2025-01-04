

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.BFDT_0Qb.js","_app/immutable/chunks/index.CxyeV82y.js","_app/immutable/chunks/vendor.BKcu9V8z.js"];
export const stylesheets = ["_app/immutable/assets/index.KLV_1GcI.css"];
export const fonts = [];
