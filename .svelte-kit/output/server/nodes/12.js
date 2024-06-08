

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.Ra0lVeRP.js","_app/immutable/chunks/index.wXjPbdew.js","_app/immutable/chunks/vendor.f5cRldcM.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
