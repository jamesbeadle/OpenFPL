

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.2435802b.js","_app/immutable/chunks/index.8f7a3bf6.js","_app/immutable/chunks/vendor.3611a370.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
