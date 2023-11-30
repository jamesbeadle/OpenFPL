

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.7ab1de55.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.30e0e13a.js","_app/immutable/chunks/singletons.b497871b.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/team-store.ba38ba75.js","_app/immutable/chunks/toast-store.fd13d56a.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.a9609e7d.js","_app/immutable/chunks/Layout.52a12f65.js","_app/immutable/chunks/governance-store.137c215b.js"];
export const stylesheets = ["_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
