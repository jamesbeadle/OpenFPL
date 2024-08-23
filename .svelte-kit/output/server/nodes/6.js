

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.Zi8Q51fc.js","_app/immutable/chunks/index.akQFABtw.js","_app/immutable/chunks/vendor.1xCNdly2.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
