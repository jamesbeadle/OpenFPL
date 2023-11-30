

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.4e117005.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.3d23771e.js","_app/immutable/chunks/singletons.0f43c887.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/team-store.1a48175b.js","_app/immutable/chunks/toast-store.fd13d56a.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.f607ef65.js","_app/immutable/chunks/Layout.0be0fcde.js","_app/immutable/chunks/governance-store.52c78378.js"];
export const stylesheets = ["_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
