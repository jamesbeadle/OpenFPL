

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.C1OxF_gQ.js","_app/immutable/chunks/index.CxyeV82y.js","_app/immutable/chunks/vendor.BKcu9V8z.js"];
export const stylesheets = ["_app/immutable/assets/index.KLV_1GcI.css"];
export const fonts = [];
