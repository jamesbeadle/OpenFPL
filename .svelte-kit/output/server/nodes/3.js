

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.5ff74a61.js","_app/immutable/chunks/index.85206748.js","_app/immutable/chunks/stores.3691cf6a.js","_app/immutable/chunks/singletons.e3eeeb27.js","_app/immutable/chunks/index.b378d913.js","_app/immutable/chunks/team-store.fa9fd22b.js","_app/immutable/chunks/toast-store.55f7539f.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/player-store.5330a1b6.js","_app/immutable/chunks/Layout.bf9e7437.js","_app/immutable/chunks/index.d7eb2526.js","_app/immutable/chunks/control.f5b05b5f.js"];
export const stylesheets = ["_app/immutable/assets/Layout.1b44d07a.css"];
export const fonts = [];
