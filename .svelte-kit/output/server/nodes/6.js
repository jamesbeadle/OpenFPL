

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.C6ffvXFr.js","_app/immutable/chunks/index.BQt4hJ4e.js","_app/immutable/chunks/vendor.BxzTRA2Y.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
