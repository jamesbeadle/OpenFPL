

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.CQ-BPQSh.js","_app/immutable/chunks/index.DwX5I7HC.js","_app/immutable/chunks/vendor.EauaSV0L.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
