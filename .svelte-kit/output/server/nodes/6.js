

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.3eTHPkNz.js","_app/immutable/chunks/index.rdxeUPOO.js","_app/immutable/chunks/vendor.VajcrWih.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
