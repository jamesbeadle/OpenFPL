

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.o93mDHwX.js","_app/immutable/chunks/index.dKPzEeoZ.js","_app/immutable/chunks/vendor.r9SrMjFO.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
