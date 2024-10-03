

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.C5_GDeix.js","_app/immutable/chunks/index.ryWaOCUa.js","_app/immutable/chunks/vendor.DNuI_ar3.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
