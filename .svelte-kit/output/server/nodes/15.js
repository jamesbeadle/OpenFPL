

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/status/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.B11eu4Qn.js","_app/immutable/chunks/index.CAttDscB.js","_app/immutable/chunks/vendor.BNOizviP.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
