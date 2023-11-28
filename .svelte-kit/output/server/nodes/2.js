

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.467b345c.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/toast-store.6633d9f4.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/manager-store.4a87cac1.js","_app/immutable/chunks/system-store.dbd4d10a.js","_app/immutable/chunks/team-store.3192300a.js","_app/immutable/chunks/Layout.71e081ca.js","_app/immutable/chunks/stores.193d467e.js","_app/immutable/chunks/singletons.20852139.js","_app/immutable/chunks/fixture-store.9be225ff.js","_app/immutable/chunks/BadgeIcon.5f1570c4.js","_app/immutable/chunks/ViewDetailsIcon.98b59799.js","_app/immutable/chunks/player-store.e6d1d691.js","_app/immutable/chunks/global-stores.803ba169.js"];
export const stylesheets = ["_app/immutable/assets/2.8041c969.css","_app/immutable/assets/Layout.1b44d07a.css"];
export const fonts = [];
