

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.w7WZ_q1j.js","_app/immutable/chunks/index.LiNz5cgR.js","_app/immutable/chunks/vendor.zVxQDvRg.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
