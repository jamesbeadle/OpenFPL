

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.D-iD15dQ.js","_app/immutable/chunks/index.DRfpNDPy.js","_app/immutable/chunks/vendor.CoTC216u.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
