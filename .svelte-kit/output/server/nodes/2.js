

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.3c33800f.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/toast-store.fd13d56a.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/manager-store.565f6fa3.js","_app/immutable/chunks/system-store.8e8e0bb2.js","_app/immutable/chunks/team-store.ba38ba75.js","_app/immutable/chunks/Layout.52a12f65.js","_app/immutable/chunks/stores.30e0e13a.js","_app/immutable/chunks/singletons.b497871b.js","_app/immutable/chunks/fixture-store.a9609e7d.js","_app/immutable/chunks/BadgeIcon.5f1570c4.js","_app/immutable/chunks/ViewDetailsIcon.98b59799.js","_app/immutable/chunks/player-store.9c35205c.js"];
export const stylesheets = ["_app/immutable/assets/2.64cc99d9.css","_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
