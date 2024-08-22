

export const index = 14;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/14.aWx6tvWH.js","_app/immutable/chunks/index.aU2k6uz2.js","_app/immutable/chunks/vendor.9RYp4bvU.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
