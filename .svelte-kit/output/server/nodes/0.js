

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.o0m5OzkC.js","_app/immutable/chunks/index.9uTZlj9k.js","_app/immutable/chunks/vendor.3SsiJdFi.js"];
export const stylesheets = ["_app/immutable/assets/index.y5qdcPzo.css"];
export const fonts = [];
