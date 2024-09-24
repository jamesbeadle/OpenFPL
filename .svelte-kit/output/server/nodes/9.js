

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.99COdV2-.js","_app/immutable/chunks/index.oUzoJ4I3.js","_app/immutable/chunks/vendor.ahlfMcBT.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
