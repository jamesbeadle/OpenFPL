

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.BbaY1_2o.js","_app/immutable/chunks/index.DR6zbDkv.js","_app/immutable/chunks/vendor.8ydUCbsy.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
