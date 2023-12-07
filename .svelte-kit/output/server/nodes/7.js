

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.c6972f3f.js","_app/immutable/chunks/index.ae36a6ca.js","_app/immutable/chunks/vendor.2b865f86.js"];
export const stylesheets = ["_app/immutable/assets/index.e6470837.css"];
export const fonts = [];
