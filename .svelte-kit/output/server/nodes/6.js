

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.BDuhAzIw.js","_app/immutable/chunks/index.IgHRWYkY.js","_app/immutable/chunks/vendor.DmPUUNwg.js"];
export const stylesheets = ["_app/immutable/assets/index.BRosPHVT.css"];
export const fonts = [];
