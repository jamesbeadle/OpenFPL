

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.D_wE6sDo.js","_app/immutable/chunks/index.DlGcK-CY.js","_app/immutable/chunks/vendor.DpV0OeN_.js"];
export const stylesheets = ["_app/immutable/assets/index.De-yblpN.css"];
export const fonts = [];
