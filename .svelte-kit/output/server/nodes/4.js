

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.ff68b0d7.js","_app/immutable/chunks/index.dab0e011.js"];
export const stylesheets = [];
export const fonts = [];
