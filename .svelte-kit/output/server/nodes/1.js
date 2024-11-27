

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.BQa1R6my.js","_app/immutable/chunks/index.rJzVYUUR.js","_app/immutable/chunks/vendor.DcPSj3Pu.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
