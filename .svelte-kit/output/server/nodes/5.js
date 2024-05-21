

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.PbCgFO1m.js","_app/immutable/chunks/index.wimO8oc4.js","_app/immutable/chunks/vendor.edlL27MF.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
