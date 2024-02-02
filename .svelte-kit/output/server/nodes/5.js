

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.488cf6d2.js","_app/immutable/chunks/index.e30514c6.js","_app/immutable/chunks/vendor.3c23d1be.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
