

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.a8274f94.js","_app/immutable/chunks/index.c7b38e5e.js"];
export const stylesheets = [];
export const fonts = [];
