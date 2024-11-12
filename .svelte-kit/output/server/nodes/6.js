

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.BB3gci4m.js","_app/immutable/chunks/index.SeitwhCX.js","_app/immutable/chunks/vendor.DZy5MdfI.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
