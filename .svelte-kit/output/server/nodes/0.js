

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.1u_PSyfF.js","_app/immutable/chunks/index.LiNz5cgR.js","_app/immutable/chunks/vendor.zVxQDvRg.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
