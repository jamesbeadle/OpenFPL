

export const index = 14;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/14.8lk3GiA2.js","_app/immutable/chunks/index.L6XScnLJ.js","_app/immutable/chunks/vendor.xOyXnCjV.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
