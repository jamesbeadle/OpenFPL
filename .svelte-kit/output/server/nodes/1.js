

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.C_wHd8o4.js","_app/immutable/chunks/index.DlGcK-CY.js","_app/immutable/chunks/vendor.DpV0OeN_.js"];
export const stylesheets = ["_app/immutable/assets/index.De-yblpN.css"];
export const fonts = [];
