

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.4e9d24a4.js","_app/immutable/chunks/index.adf007de.js","_app/immutable/chunks/vendor.386b8abb.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
