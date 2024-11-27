

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.D16Xo3L3.js","_app/immutable/chunks/index.rJzVYUUR.js","_app/immutable/chunks/vendor.DcPSj3Pu.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
