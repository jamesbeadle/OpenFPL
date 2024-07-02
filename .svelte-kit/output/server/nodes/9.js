

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.nSj8scpl.js","_app/immutable/chunks/index.GyPKHwEb.js","_app/immutable/chunks/vendor.ouuYzY3k.js"];
export const stylesheets = ["_app/immutable/assets/index.KveW6Omx.css"];
export const fonts = [];
