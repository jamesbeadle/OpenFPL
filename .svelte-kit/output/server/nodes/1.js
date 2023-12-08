

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.16633a09.js","_app/immutable/chunks/index.709e150e.js","_app/immutable/chunks/vendor.915501b0.js"];
export const stylesheets = ["_app/immutable/assets/index.507befdb.css"];
export const fonts = [];
