

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.oXJ46Ql8.js","_app/immutable/chunks/index.SeitwhCX.js","_app/immutable/chunks/vendor.DZy5MdfI.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
