

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.0bAGHv1i.js","_app/immutable/chunks/index.oUzoJ4I3.js","_app/immutable/chunks/vendor.ahlfMcBT.js"];
export const stylesheets = ["_app/immutable/assets/index.o1ujAWz-.css"];
export const fonts = [];
