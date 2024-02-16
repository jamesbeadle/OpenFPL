

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.Ah0wZYO1.js","_app/immutable/chunks/index.18tCYbqf.js","_app/immutable/chunks/vendor.F6kRLxTH.js"];
export const stylesheets = ["_app/immutable/assets/index.ZONkP7mR.css"];
export const fonts = [];
