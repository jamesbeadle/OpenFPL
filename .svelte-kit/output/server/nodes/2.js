

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.a0c3d0d8.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/toast-store.fd13d56a.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/manager-store.e3405259.js","_app/immutable/chunks/system-store.3e6f7264.js","_app/immutable/chunks/team-store.1a48175b.js","_app/immutable/chunks/Layout.731063fd.js","_app/immutable/chunks/stores.40caf0aa.js","_app/immutable/chunks/singletons.59e6ee46.js","_app/immutable/chunks/fixture-store.f607ef65.js","_app/immutable/chunks/BadgeIcon.5f1570c4.js","_app/immutable/chunks/ViewDetailsIcon.98b59799.js","_app/immutable/chunks/player-store.f468e323.js"];
export const stylesheets = ["_app/immutable/assets/2.64cc99d9.css","_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
