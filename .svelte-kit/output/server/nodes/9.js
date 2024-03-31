

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9._HEAVhH5.js","_app/immutable/chunks/index.j_1oWw4i.js","_app/immutable/chunks/vendor.0f9yKWfc.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
