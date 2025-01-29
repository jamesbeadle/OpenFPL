

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.BKAzpVmR.js","_app/immutable/chunks/index.qwFTu3Q2.js","_app/immutable/chunks/vendor.BwqKQRR-.js"];
export const stylesheets = ["_app/immutable/assets/index.DI_gyc2R.css"];
export const fonts = [];
