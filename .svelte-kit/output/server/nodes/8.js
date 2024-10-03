

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.Cizn6zsT.js","_app/immutable/chunks/index.ryWaOCUa.js","_app/immutable/chunks/vendor.DNuI_ar3.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
