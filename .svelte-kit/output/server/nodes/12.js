

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.D2jTipie.js","_app/immutable/chunks/index.DwX5I7HC.js","_app/immutable/chunks/vendor.EauaSV0L.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
