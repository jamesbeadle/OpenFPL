

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.PJ-HyiK1.js","_app/immutable/chunks/index.XgqFV-fJ.js","_app/immutable/chunks/vendor.ElQ2X59X.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
