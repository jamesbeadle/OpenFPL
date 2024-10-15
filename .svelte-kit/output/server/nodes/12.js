

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.C6DNl9sl.js","_app/immutable/chunks/index.IgHRWYkY.js","_app/immutable/chunks/vendor.DmPUUNwg.js"];
export const stylesheets = ["_app/immutable/assets/index.BRosPHVT.css"];
export const fonts = [];
