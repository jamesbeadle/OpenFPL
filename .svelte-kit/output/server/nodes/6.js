

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.7dZenTpO.js","_app/immutable/chunks/index.XBVcI7d5.js","_app/immutable/chunks/vendor.H7vjXcyj.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
