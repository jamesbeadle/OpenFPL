

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.DjRhtW0u.js","_app/immutable/chunks/index.BleXLFIa.js","_app/immutable/chunks/vendor.DCEJCOGa.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
