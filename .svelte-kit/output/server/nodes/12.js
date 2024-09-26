

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.xbdzW2tN.js","_app/immutable/chunks/index.CAaX1OxE.js","_app/immutable/chunks/vendor.CuL5JgGp.js"];
export const stylesheets = ["_app/immutable/assets/index.Bsw_5pHn.css"];
export const fonts = [];
