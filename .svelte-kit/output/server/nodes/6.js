

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.imvU6307.js","_app/immutable/chunks/index.qDuaNaTX.js","_app/immutable/chunks/vendor.Dx-udI4k.js"];
export const stylesheets = ["_app/immutable/assets/index.VpFtjrHf.css"];
export const fonts = [];
