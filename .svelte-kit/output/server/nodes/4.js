

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.BtJ1Z6Ks.js","_app/immutable/chunks/index.BdXEDTRh.js","_app/immutable/chunks/vendor.D_ZGNa3I.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
