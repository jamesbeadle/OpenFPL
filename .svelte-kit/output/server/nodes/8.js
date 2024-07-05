

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.nmn2Vu4y.js","_app/immutable/chunks/index.XnuAnO2E.js","_app/immutable/chunks/vendor.PFno64BW.js"];
export const stylesheets = ["_app/immutable/assets/index.KveW6Omx.css"];
export const fonts = [];
