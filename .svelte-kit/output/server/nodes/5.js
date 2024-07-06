

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.FyP4ii7U.js","_app/immutable/chunks/index.woVUDmiI.js","_app/immutable/chunks/vendor._1GvFhzy.js"];
export const stylesheets = ["_app/immutable/assets/index.5tzJ8ldi.css"];
export const fonts = [];
