

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.9pxFkcz3.js","_app/immutable/chunks/index.kJEWWSKC.js","_app/immutable/chunks/vendor.rMpq-Zhx.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
