

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.01c40ebf.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.193d467e.js","_app/immutable/chunks/singletons.20852139.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/team-store.3192300a.js","_app/immutable/chunks/toast-store.6633d9f4.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.9be225ff.js","_app/immutable/chunks/index.d7eb2526.js","_app/immutable/chunks/control.f5b05b5f.js","_app/immutable/chunks/Layout.71e081ca.js","_app/immutable/chunks/governance-store.48fd731d.js"];
export const stylesheets = ["_app/immutable/assets/Layout.1b44d07a.css"];
export const fonts = [];
