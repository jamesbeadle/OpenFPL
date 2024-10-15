

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.BACeqnb0.js","_app/immutable/chunks/index.yexfBKWD.js","_app/immutable/chunks/vendor.DcmAcygx.js"];
export const stylesheets = ["_app/immutable/assets/index.De-yblpN.css"];
export const fonts = [];
