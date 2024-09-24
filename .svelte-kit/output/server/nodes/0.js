

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.HIjRlsCE.js","_app/immutable/chunks/index.idDtaoZy.js","_app/immutable/chunks/vendor.6Sq69bjG.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
