

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.3009d0a5.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/Layout.a37f6ebe.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/stores.c472e708.js","_app/immutable/chunks/singletons.803c1c81.js","_app/immutable/chunks/toast-store.ddf69d4c.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
