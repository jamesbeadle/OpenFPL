

export const index = 15;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/15.trNaj1h6.js","_app/immutable/chunks/index.woVUDmiI.js","_app/immutable/chunks/vendor._1GvFhzy.js"];
export const stylesheets = ["_app/immutable/assets/index.5tzJ8ldi.css"];
export const fonts = [];
