

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.6o1SVNc6.js","_app/immutable/chunks/index.Ky0yPQg5.js","_app/immutable/chunks/vendor.ZTqqCDw6.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
