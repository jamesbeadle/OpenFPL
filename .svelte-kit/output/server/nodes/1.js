

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.1c10f068.js","_app/immutable/chunks/index.f1e93ddb.js","_app/immutable/chunks/vendor.cb9ca98f.js"];
export const stylesheets = ["_app/immutable/assets/index.78e714a3.css"];
export const fonts = [];
