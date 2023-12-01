

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.95cfb0ce.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/toast-store.d087d6cb.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/manager-store.44f90590.js","_app/immutable/chunks/system-store.bab4432e.js","_app/immutable/chunks/team-store.ca59477e.js","_app/immutable/chunks/Layout.b02e4571.js","_app/immutable/chunks/stores.c13fa1c0.js","_app/immutable/chunks/singletons.04c19f05.js","_app/immutable/chunks/fixture-store.ccd493d7.js","_app/immutable/chunks/BadgeIcon.5f1570c4.js","_app/immutable/chunks/ViewDetailsIcon.98b59799.js","_app/immutable/chunks/player-store.2e33765e.js"];
export const stylesheets = ["_app/immutable/assets/2.64cc99d9.css","_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
