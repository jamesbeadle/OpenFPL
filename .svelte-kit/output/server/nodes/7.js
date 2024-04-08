

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.QD3HzYV_.js","_app/immutable/chunks/index.kKnhXFH0.js","_app/immutable/chunks/vendor.tnlMUMas.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
