

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.WL2ox_cP.js","_app/immutable/chunks/index.akQFABtw.js","_app/immutable/chunks/vendor.1xCNdly2.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
