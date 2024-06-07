

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.VYKqsCjy.js","_app/immutable/chunks/index.XgqFV-fJ.js","_app/immutable/chunks/vendor.ElQ2X59X.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
