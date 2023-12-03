

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.23641ce7.js","_app/immutable/chunks/scheduler.2037d42e.js","_app/immutable/chunks/index.cd713282.js"];
export const stylesheets = [];
export const fonts = [];
