

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.X7fYk3K_.js","_app/immutable/chunks/index.2nilvyiv.js","_app/immutable/chunks/vendor.ILkoeDdy.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
