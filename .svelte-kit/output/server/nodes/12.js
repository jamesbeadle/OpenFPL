

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.i7_Rld9B.js","_app/immutable/chunks/index.jgP9jj1k.js","_app/immutable/chunks/vendor.P1htvnIr.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
