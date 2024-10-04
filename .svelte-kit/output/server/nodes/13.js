

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.DSNli8Jb.js","_app/immutable/chunks/index.DRfpNDPy.js","_app/immutable/chunks/vendor.CoTC216u.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
