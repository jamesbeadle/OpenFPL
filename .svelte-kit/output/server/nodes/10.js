

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.510777f3.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/stores.46fe71ba.js","_app/immutable/chunks/singletons.095fe9e5.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/toast-store.6633d9f4.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/global-stores.803ba169.js","_app/immutable/chunks/system-store.7be81c44.js","_app/immutable/chunks/team-store.5723d493.js","_app/immutable/chunks/Layout.a0c76cdc.js","_app/immutable/chunks/fixture-store.43de3d27.js","_app/immutable/chunks/BadgeIcon.5f1570c4.js","_app/immutable/chunks/ViewDetailsIcon.98b59799.js","_app/immutable/chunks/player-store.f7250a59.js","_app/immutable/chunks/ShirtIcon.cbb688e3.js"];
export const stylesheets = ["_app/immutable/assets/10.7515d509.css","_app/immutable/assets/Layout.1b44d07a.css"];
export const fonts = [];
