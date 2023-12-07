

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.5cba074e.js","_app/immutable/chunks/index.2cecf91d.js","_app/immutable/chunks/vendor.2353e400.js"];
export const stylesheets = ["_app/immutable/assets/index.4609496a.css"];
export const fonts = [];
