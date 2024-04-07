

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.0WqezIGy.js","_app/immutable/chunks/index.ylFwoe15.js","_app/immutable/chunks/vendor.0tTkDG0T.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
