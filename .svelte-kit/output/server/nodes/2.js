

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.Qzsao5Fb.js","_app/immutable/chunks/index.XBVcI7d5.js","_app/immutable/chunks/vendor.H7vjXcyj.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
