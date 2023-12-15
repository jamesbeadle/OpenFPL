

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.ef2a0cd1.js","_app/immutable/chunks/index.8e3a55b8.js","_app/immutable/chunks/vendor.bc4e2350.js"];
export const stylesheets = ["_app/immutable/assets/index.fa34df7c.css"];
export const fonts = [];
