

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.0fd2b21b.js","_app/immutable/chunks/index.adf007de.js","_app/immutable/chunks/vendor.386b8abb.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
