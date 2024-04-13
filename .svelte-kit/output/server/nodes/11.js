

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.jaO-5Sha.js","_app/immutable/chunks/index.tUkbMj2n.js","_app/immutable/chunks/vendor.oHIznVFi.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
