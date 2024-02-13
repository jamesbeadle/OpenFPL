

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.agxFEn-g.js","_app/immutable/chunks/index.ckeBYQaT.js","_app/immutable/chunks/vendor.hsIoeDGN.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
