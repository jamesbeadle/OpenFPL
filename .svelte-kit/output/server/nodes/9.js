

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.9194b519.js","_app/immutable/chunks/index.0a167d6e.js","_app/immutable/chunks/vendor.0cb9e25e.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
