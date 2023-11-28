

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.050a4bf1.js","_app/immutable/chunks/index.85206748.js","_app/immutable/chunks/toast-store.55f7539f.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/index.b378d913.js"];
export const stylesheets = [];
export const fonts = [];
