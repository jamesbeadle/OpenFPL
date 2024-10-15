

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.C2U6ZZTz.js","_app/immutable/chunks/index.yexfBKWD.js","_app/immutable/chunks/vendor.DcmAcygx.js"];
export const stylesheets = ["_app/immutable/assets/index.De-yblpN.css"];
export const fonts = [];
