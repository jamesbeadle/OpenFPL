

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.2a4d60d5.js","_app/immutable/chunks/index.b324a1dd.js"];
export const stylesheets = [];
export const fonts = [];
