

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.fef7c30f.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/Layout.1bcae1a2.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/stores.d5870709.js","_app/immutable/chunks/singletons.2804915a.js","_app/immutable/chunks/Helpers.c6feb0fc.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.c34298fa.css"];
export const fonts = [];
