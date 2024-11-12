

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.sEZgtkdF.js","_app/immutable/chunks/index.ix2MojeR.js","_app/immutable/chunks/vendor.CQAfaw0E.js"];
export const stylesheets = ["_app/immutable/assets/index.Cxb9CIm_.css"];
export const fonts = [];
