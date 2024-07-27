

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/logs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.DBd2di6v.js","_app/immutable/chunks/index.fLWMtExJ.js","_app/immutable/chunks/vendor.ZIwSoOEL.js"];
export const stylesheets = ["_app/immutable/assets/index.o9HS5YSy.css"];
export const fonts = [];
