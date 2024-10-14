

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.B1QdL7QI.js","_app/immutable/chunks/index.HccoOBdW.js","_app/immutable/chunks/vendor.C5ktInnC.js"];
export const stylesheets = ["_app/immutable/assets/index.BRosPHVT.css"];
export const fonts = [];
