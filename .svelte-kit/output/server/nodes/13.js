

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.3rMZU0a-.js","_app/immutable/chunks/index.L6XScnLJ.js","_app/immutable/chunks/vendor.xOyXnCjV.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
