

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.hl0I_kny.js","_app/immutable/chunks/index.6Yh0ZiaA.js","_app/immutable/chunks/vendor.CP6HMVig.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
