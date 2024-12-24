

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.BHUht81W.js","_app/immutable/chunks/index.DRQMFHf6.js","_app/immutable/chunks/vendor.aknFWF4V.js"];
export const stylesheets = ["_app/immutable/assets/index.CFtEAVJi.css"];
export const fonts = [];
