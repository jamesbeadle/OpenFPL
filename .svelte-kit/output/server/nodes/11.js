

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.Y7_nyiOJ.js","_app/immutable/chunks/index.j_1oWw4i.js","_app/immutable/chunks/vendor.0f9yKWfc.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
