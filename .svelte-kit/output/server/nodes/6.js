

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.DUOWpACX.js","_app/immutable/chunks/index.DjquHYxb.js","_app/immutable/chunks/vendor.CWgSn_oz.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
