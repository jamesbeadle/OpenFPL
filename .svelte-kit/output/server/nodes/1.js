

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.RW7SAlKY.js","_app/immutable/chunks/index.kKnhXFH0.js","_app/immutable/chunks/vendor.tnlMUMas.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
