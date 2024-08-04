

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.icRrozHx.js","_app/immutable/chunks/index.4teuIj9I.js","_app/immutable/chunks/vendor.54n7CTcV.js"];
export const stylesheets = ["_app/immutable/assets/index.o9HS5YSy.css"];
export const fonts = [];
