

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.e4e59fc3.js","_app/immutable/chunks/index.2c980fd1.js","_app/immutable/chunks/vendor.1292ff6a.js"];
export const stylesheets = ["_app/immutable/assets/index.5b660869.css"];
export const fonts = [];
