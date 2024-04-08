

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.Ima7LMoA.js","_app/immutable/chunks/index.kKnhXFH0.js","_app/immutable/chunks/vendor.tnlMUMas.js"];
export const stylesheets = ["_app/immutable/assets/index.j2pPQJj6.css"];
export const fonts = [];
