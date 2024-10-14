

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.CSc0evBh.js","_app/immutable/chunks/index.HccoOBdW.js","_app/immutable/chunks/vendor.C5ktInnC.js"];
export const stylesheets = ["_app/immutable/assets/index.BRosPHVT.css"];
export const fonts = [];
