

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.f6766aae.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/Layout.4ea1ffce.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/stores.bf47915d.js","_app/immutable/chunks/singletons.c3049c55.js","_app/immutable/chunks/toast-store.d43f66ba.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/6.2206b352.css","_app/immutable/assets/Layout.306651eb.css"];
export const fonts = [];
