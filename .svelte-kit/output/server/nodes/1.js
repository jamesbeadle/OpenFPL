

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.Hv5R4Div.js","_app/immutable/chunks/index.jgP9jj1k.js","_app/immutable/chunks/vendor.P1htvnIr.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
