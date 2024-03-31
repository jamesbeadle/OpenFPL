

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.Y1USRNr3.js","_app/immutable/chunks/index.qtqbg87e.js","_app/immutable/chunks/vendor.nXjeGEC7.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
