

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.BfTSMJWJ.js","_app/immutable/chunks/index.oUzoJ4I3.js","_app/immutable/chunks/vendor.ahlfMcBT.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
