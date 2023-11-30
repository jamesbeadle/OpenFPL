

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.217c449a.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.c5bfb51d.js","_app/immutable/chunks/singletons.b9725106.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/team-store.0593af6d.js","_app/immutable/chunks/toast-store.d087d6cb.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.50d7b9f2.js","_app/immutable/chunks/Layout.06fdbfa3.js","_app/immutable/chunks/governance-store.c70dd84b.js"];
export const stylesheets = ["_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
