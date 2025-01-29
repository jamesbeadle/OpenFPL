

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.BLnREg1h.js","_app/immutable/chunks/index.qwFTu3Q2.js","_app/immutable/chunks/vendor.BwqKQRR-.js"];
export const stylesheets = ["_app/immutable/assets/index.DI_gyc2R.css"];
export const fonts = [];
