

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.deefba20.js","_app/immutable/chunks/index.6dba6488.js","_app/immutable/chunks/singletons.0757534f.js"];
export const stylesheets = [];
export const fonts = [];
