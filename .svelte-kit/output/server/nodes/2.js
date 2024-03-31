

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.fBSwxGwX.js","_app/immutable/chunks/index.qtqbg87e.js","_app/immutable/chunks/vendor.nXjeGEC7.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
