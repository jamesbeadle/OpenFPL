

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.mo0LytYn.js","_app/immutable/chunks/index.TEOd8Slp.js","_app/immutable/chunks/vendor.QgrOUDtg.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
