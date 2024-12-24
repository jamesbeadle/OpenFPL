

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/canisters/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.CY7OMmDj.js","_app/immutable/chunks/index.DRQMFHf6.js","_app/immutable/chunks/vendor.aknFWF4V.js"];
export const stylesheets = ["_app/immutable/assets/index.CFtEAVJi.css"];
export const fonts = [];
