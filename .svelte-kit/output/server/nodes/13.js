

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.CHkQbkcG.js","_app/immutable/chunks/index.yexfBKWD.js","_app/immutable/chunks/vendor.DcmAcygx.js"];
export const stylesheets = ["_app/immutable/assets/index.De-yblpN.css"];
export const fonts = [];
