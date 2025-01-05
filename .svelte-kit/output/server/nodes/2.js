

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.C8rWw7II.js","_app/immutable/chunks/index.DR6zbDkv.js","_app/immutable/chunks/vendor.8ydUCbsy.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
