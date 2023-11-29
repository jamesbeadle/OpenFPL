

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.bd060bff.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.f0f38284.js","_app/immutable/chunks/singletons.f40d3e23.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/toast-store.64ad2768.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/global-stores.803ba169.js","_app/immutable/chunks/system-store.408d352e.js","_app/immutable/chunks/team-store.a9afdac8.js","_app/immutable/chunks/Layout.39e2a716.js","_app/immutable/chunks/fixture-store.8fe042dd.js","_app/immutable/chunks/BadgeIcon.5f1570c4.js","_app/immutable/chunks/ViewDetailsIcon.98b59799.js","_app/immutable/chunks/player-store.55a4cc5d.js","_app/immutable/chunks/ShirtIcon.cbb688e3.js"];
export const stylesheets = ["_app/immutable/assets/10.7515d509.css","_app/immutable/assets/Layout.1b44d07a.css"];
export const fonts = [];
