

export const index = 18;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/18.6apoc1lm.js","_app/immutable/chunks/index.TEOd8Slp.js","_app/immutable/chunks/vendor.QgrOUDtg.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
