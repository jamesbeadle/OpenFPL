

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.6os0xf3A.js","_app/immutable/chunks/index.DR6zbDkv.js","_app/immutable/chunks/vendor.8ydUCbsy.js"];
export const stylesheets = ["_app/immutable/assets/index.B43uisNd.css"];
export const fonts = [];
