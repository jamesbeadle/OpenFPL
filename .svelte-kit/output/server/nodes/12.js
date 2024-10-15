

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.DUI4so_K.js","_app/immutable/chunks/index.yexfBKWD.js","_app/immutable/chunks/vendor.DcmAcygx.js"];
export const stylesheets = ["_app/immutable/assets/index.De-yblpN.css"];
export const fonts = [];
