

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.Bn8JF-Wo.js","_app/immutable/chunks/index.DvzIa2QR.js","_app/immutable/chunks/vendor.DE5Sqftm.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
