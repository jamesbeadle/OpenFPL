

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.23e8668a.js","_app/immutable/chunks/index.7fb8d1f9.js","_app/immutable/chunks/vendor.c4358ad6.js"];
export const stylesheets = ["_app/immutable/assets/index.87959933.css"];
export const fonts = [];
