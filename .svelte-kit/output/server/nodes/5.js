

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.I1yhqEfn.js","_app/immutable/chunks/index.TEOd8Slp.js","_app/immutable/chunks/vendor.QgrOUDtg.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
