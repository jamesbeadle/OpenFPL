

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.uAvFkeCY.js","_app/immutable/chunks/index.idDtaoZy.js","_app/immutable/chunks/vendor.6Sq69bjG.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
