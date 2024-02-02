

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.b3905be2.js","_app/immutable/chunks/index.e30514c6.js","_app/immutable/chunks/vendor.3c23d1be.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
