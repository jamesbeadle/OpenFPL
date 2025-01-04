

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.Bgsmxs4w.js","_app/immutable/chunks/index.CxyeV82y.js","_app/immutable/chunks/vendor.BKcu9V8z.js"];
export const stylesheets = ["_app/immutable/assets/index.KLV_1GcI.css"];
export const fonts = [];
