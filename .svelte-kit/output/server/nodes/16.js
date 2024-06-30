

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.N8h7iuhQ.js","_app/immutable/chunks/index.9uTZlj9k.js","_app/immutable/chunks/vendor.3SsiJdFi.js"];
export const stylesheets = ["_app/immutable/assets/index.y5qdcPzo.css"];
export const fonts = [];
