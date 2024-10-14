

export const index = 17;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/17.BOUOoKV5.js","_app/immutable/chunks/index.HccoOBdW.js","_app/immutable/chunks/vendor.C5ktInnC.js"];
export const stylesheets = ["_app/immutable/assets/index.BRosPHVT.css"];
export const fonts = [];
