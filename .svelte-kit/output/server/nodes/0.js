

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.63b63d5c.js","_app/immutable/chunks/index.e590a2b1.js"];
export const stylesheets = [];
export const fonts = [];
