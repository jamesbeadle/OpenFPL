

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.60b999e2.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.c472e708.js","_app/immutable/chunks/singletons.803c1c81.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/team-store.38ee0fd3.js","_app/immutable/chunks/toast-store.ddf69d4c.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.6d59531b.js","_app/immutable/chunks/Layout.a37f6ebe.js","_app/immutable/chunks/governance-store.94f10982.js"];
export const stylesheets = ["_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
