

export const index = 18;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/18.iKI41OSa.js","_app/immutable/chunks/index.ZQIWTQuH.js","_app/immutable/chunks/vendor.j1f6q512.js"];
export const stylesheets = ["_app/immutable/assets/index.mcsfG68k.css"];
export const fonts = [];
