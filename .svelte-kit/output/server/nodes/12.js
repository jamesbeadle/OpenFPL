

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.khk6V6Ie.js","_app/immutable/chunks/index.qtqbg87e.js","_app/immutable/chunks/vendor.nXjeGEC7.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
