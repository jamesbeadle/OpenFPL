

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.f8d8edef.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/Layout.0578a0e9.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/stores.e742c101.js","_app/immutable/chunks/singletons.bd68a825.js","_app/immutable/chunks/toast-store.4fb1a6f1.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
