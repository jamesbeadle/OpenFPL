

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.4WY17L9N.js","_app/immutable/chunks/index.2nilvyiv.js","_app/immutable/chunks/vendor.ILkoeDdy.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
