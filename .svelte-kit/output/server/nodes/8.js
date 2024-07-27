

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.3Grhe9Ii.js","_app/immutable/chunks/index.fLWMtExJ.js","_app/immutable/chunks/vendor.ZIwSoOEL.js"];
export const stylesheets = ["_app/immutable/assets/index.o9HS5YSy.css"];
export const fonts = [];
