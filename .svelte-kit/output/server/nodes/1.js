

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.DLJpyKxr.js","_app/immutable/chunks/index.B7xrigMo.js","_app/immutable/chunks/vendor.Bft4PkYq.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
