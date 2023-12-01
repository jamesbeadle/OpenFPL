

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.257b5af1.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/stores.3a27911b.js","_app/immutable/chunks/singletons.76216e9a.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/team-store.b04b0b2e.js","_app/immutable/chunks/toast-store.0b82f89c.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.4a74b834.js","_app/immutable/chunks/Layout.d10cf2e0.js","_app/immutable/chunks/governance-store.35e8b8cc.js"];
export const stylesheets = ["_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
