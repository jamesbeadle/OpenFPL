

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.MhhVuu6i.js","_app/immutable/chunks/index.dKPzEeoZ.js","_app/immutable/chunks/vendor.r9SrMjFO.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
