

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.BPgL9PcA.js","_app/immutable/chunks/index.CAaX1OxE.js","_app/immutable/chunks/vendor.CuL5JgGp.js"];
export const stylesheets = ["_app/immutable/assets/index.Bsw_5pHn.css"];
export const fonts = [];
