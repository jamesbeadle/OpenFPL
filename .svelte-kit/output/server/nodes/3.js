

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.DOwSpr3D.js","_app/immutable/chunks/index.oUzoJ4I3.js","_app/immutable/chunks/vendor.ahlfMcBT.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
