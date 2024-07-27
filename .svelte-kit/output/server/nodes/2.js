

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.nD3TmZrc.js","_app/immutable/chunks/index.fLWMtExJ.js","_app/immutable/chunks/vendor.ZIwSoOEL.js"];
export const stylesheets = ["_app/immutable/assets/index.o9HS5YSy.css"];
export const fonts = [];
