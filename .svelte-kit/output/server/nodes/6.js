

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.B3PZyHK0.js","_app/immutable/chunks/index.DRQMFHf6.js","_app/immutable/chunks/vendor.aknFWF4V.js"];
export const stylesheets = ["_app/immutable/assets/index.CFtEAVJi.css"];
export const fonts = [];
