

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.E7P0k5p8.js","_app/immutable/chunks/index.Bauat46B.js","_app/immutable/chunks/vendor.lPFtkSVl.js"];
export const stylesheets = ["_app/immutable/assets/index.Bsw_5pHn.css"];
export const fonts = [];
