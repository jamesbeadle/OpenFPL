

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.BEPGfuLf.js","_app/immutable/chunks/index.DlGcK-CY.js","_app/immutable/chunks/vendor.DpV0OeN_.js"];
export const stylesheets = ["_app/immutable/assets/index.De-yblpN.css"];
export const fonts = [];
