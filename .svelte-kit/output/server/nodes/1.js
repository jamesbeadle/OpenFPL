

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.c4706c64.js","_app/immutable/chunks/index.39db584a.js","_app/immutable/chunks/vendor.398a4dc8.js"];
export const stylesheets = ["_app/immutable/assets/index.862f8b2a.css"];
export const fonts = [];
