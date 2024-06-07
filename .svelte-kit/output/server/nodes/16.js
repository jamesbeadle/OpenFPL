

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.0voR6Dn8.js","_app/immutable/chunks/index.XgqFV-fJ.js","_app/immutable/chunks/vendor.ElQ2X59X.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
