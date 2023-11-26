

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.0d077170.js","_app/immutable/chunks/index.dab0e011.js"];
export const stylesheets = [];
export const fonts = [];
