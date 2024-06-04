

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/logs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.9uY-usJ3.js","_app/immutable/chunks/index.ZQIWTQuH.js","_app/immutable/chunks/vendor.j1f6q512.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
