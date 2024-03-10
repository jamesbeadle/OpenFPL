

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.ZRSohI-2.js","_app/immutable/chunks/index.Ky0yPQg5.js","_app/immutable/chunks/vendor.ZTqqCDw6.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
