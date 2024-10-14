

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.SVdCoA6c.js","_app/immutable/chunks/index.HccoOBdW.js","_app/immutable/chunks/vendor.C5ktInnC.js"];
export const stylesheets = ["_app/immutable/assets/index.BRosPHVT.css"];
export const fonts = [];
