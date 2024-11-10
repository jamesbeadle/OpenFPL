

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.CmzKD9-1.js","_app/immutable/chunks/index.DjquHYxb.js","_app/immutable/chunks/vendor.CWgSn_oz.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
