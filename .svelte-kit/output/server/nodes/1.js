

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.55650901.js","_app/immutable/chunks/scheduler.2037d42e.js","_app/immutable/chunks/index.cd713282.js","_app/immutable/chunks/stores.2a5d2c72.js","_app/immutable/chunks/singletons.4e632dcd.js"];
export const stylesheets = [];
export const fonts = [];
