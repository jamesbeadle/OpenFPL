

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.D4KnW0eu.js","_app/immutable/chunks/index.DvzIa2QR.js","_app/immutable/chunks/vendor.DE5Sqftm.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
