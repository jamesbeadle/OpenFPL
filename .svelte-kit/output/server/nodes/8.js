

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.f1e86b7a.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.f0f38284.js","_app/immutable/chunks/singletons.f40d3e23.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/team-store.a9afdac8.js","_app/immutable/chunks/toast-store.64ad2768.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/system-store.408d352e.js","_app/immutable/chunks/manager-store.58a33dc2.js","_app/immutable/chunks/Layout.39e2a716.js","_app/immutable/chunks/player-store.55a4cc5d.js","_app/immutable/chunks/fixture-store.8fe042dd.js","_app/immutable/chunks/BadgeIcon.5f1570c4.js","_app/immutable/chunks/manager-gameweeks.bd195a5b.js","_app/immutable/chunks/ViewDetailsIcon.98b59799.js","_app/immutable/chunks/global-stores.803ba169.js"];
export const stylesheets = ["_app/immutable/assets/Layout.1b44d07a.css"];
export const fonts = [];
