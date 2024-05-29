

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.V5STo-Ii.js","_app/immutable/chunks/index.2nilvyiv.js","_app/immutable/chunks/vendor.ILkoeDdy.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
