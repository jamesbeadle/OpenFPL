

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.3d82f49d.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/Layout.d10cf2e0.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/stores.3a27911b.js","_app/immutable/chunks/singletons.76216e9a.js","_app/immutable/chunks/toast-store.0b82f89c.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/6.2206b352.css","_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
