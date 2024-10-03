

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.D7KexcVv.js","_app/immutable/chunks/index.-KV3YYlW.js","_app/immutable/chunks/vendor.BxOc8Sc_.js"];
export const stylesheets = ["_app/immutable/assets/index.TTx05D_Z.css"];
export const fonts = [];
