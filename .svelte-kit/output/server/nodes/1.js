

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.66a128c3.js","_app/immutable/chunks/index.878abf19.js","_app/immutable/chunks/stores.8fa21572.js","_app/immutable/chunks/singletons.6a8625ca.js"];
export const stylesheets = [];
export const fonts = [];
