

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.dd4718d0.js","_app/immutable/chunks/index.befd7e53.js","_app/immutable/chunks/vendor.d3e2a78a.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
