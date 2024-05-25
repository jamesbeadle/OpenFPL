

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.T6jDH1t-.js","_app/immutable/chunks/index.kJEWWSKC.js","_app/immutable/chunks/vendor.rMpq-Zhx.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
