

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.cbf74d32.js","_app/immutable/chunks/index.aa733771.js","_app/immutable/chunks/Layout.79823031.js","_app/immutable/chunks/stores.897bcf18.js","_app/immutable/chunks/singletons.1877a767.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.679ed808.css"];
export const fonts = [];
