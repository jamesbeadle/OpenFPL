

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.T_WgMrs-.js","_app/immutable/chunks/index.fgbIxJ77.js","_app/immutable/chunks/vendor.y-ZjmoEQ.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
