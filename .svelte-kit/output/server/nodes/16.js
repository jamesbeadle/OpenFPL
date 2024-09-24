

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/status/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.YBStJJlB.js","_app/immutable/chunks/index.oUzoJ4I3.js","_app/immutable/chunks/vendor.ahlfMcBT.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
