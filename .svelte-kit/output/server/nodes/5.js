

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.heuDL_gm.js","_app/immutable/chunks/index.HccoOBdW.js","_app/immutable/chunks/vendor.C5ktInnC.js"];
export const stylesheets = ["_app/immutable/assets/index.BRosPHVT.css"];
export const fonts = [];
