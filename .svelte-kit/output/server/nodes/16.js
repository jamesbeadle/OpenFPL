

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/status/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.q38IT4Ia.js","_app/immutable/chunks/index.idDtaoZy.js","_app/immutable/chunks/vendor.6Sq69bjG.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
