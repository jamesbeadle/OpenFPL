

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.cbd53ab4.js","_app/immutable/chunks/index.1900cb6b.js","_app/immutable/chunks/vendor.7c12f112.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
