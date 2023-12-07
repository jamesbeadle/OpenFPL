

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.7aedc263.js","_app/immutable/chunks/index.2f2fe72d.js","_app/immutable/chunks/vendor.1e5b4dca.js"];
export const stylesheets = ["_app/immutable/assets/index.b7aec314.css"];
export const fonts = [];
