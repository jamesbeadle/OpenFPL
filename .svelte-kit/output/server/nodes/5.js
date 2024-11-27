

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.Rx8p7-UF.js","_app/immutable/chunks/index.CtMgl_NB.js","_app/immutable/chunks/vendor.D7hZaGI6.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
