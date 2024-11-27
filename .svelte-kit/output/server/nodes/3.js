

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/canisters/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.BXP7Cno4.js","_app/immutable/chunks/index.CtMgl_NB.js","_app/immutable/chunks/vendor.D7hZaGI6.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
