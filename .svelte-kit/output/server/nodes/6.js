

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.CCoHF3n1.js","_app/immutable/chunks/index.D_Feu3Gc.js","_app/immutable/chunks/vendor.D6wBz0PL.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
