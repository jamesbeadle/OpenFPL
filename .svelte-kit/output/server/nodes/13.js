

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.4CuUpS2P.js","_app/immutable/chunks/index.kKnhXFH0.js","_app/immutable/chunks/vendor.tnlMUMas.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
