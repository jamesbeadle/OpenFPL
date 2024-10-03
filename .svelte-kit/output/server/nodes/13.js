

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.CgoTYHcs.js","_app/immutable/chunks/index.-KV3YYlW.js","_app/immutable/chunks/vendor.BxOc8Sc_.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
