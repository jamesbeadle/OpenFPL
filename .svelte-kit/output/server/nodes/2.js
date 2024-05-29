

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.r_kBFRy6.js","_app/immutable/chunks/index.2nilvyiv.js","_app/immutable/chunks/vendor.ILkoeDdy.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
