

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.28f7cbf5.js","_app/immutable/chunks/index.d2fad0ed.js","_app/immutable/chunks/vendor.69eaddaa.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
