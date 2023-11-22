

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.ec1bf418.js","_app/immutable/chunks/index.878abf19.js"];
export const stylesheets = [];
export const fonts = [];
