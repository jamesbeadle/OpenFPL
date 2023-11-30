

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.b77a548f.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.40caf0aa.js","_app/immutable/chunks/singletons.59e6ee46.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/team-store.1a48175b.js","_app/immutable/chunks/toast-store.fd13d56a.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.f607ef65.js","_app/immutable/chunks/Layout.731063fd.js","_app/immutable/chunks/governance-store.52c78378.js"];
export const stylesheets = ["_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
