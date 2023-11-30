

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.b33666c4.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/Layout.a538b3b7.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/stores.f89c8fde.js","_app/immutable/chunks/singletons.fe993027.js","_app/immutable/chunks/toast-store.58fa49f6.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/system-store.28344883.js","_app/immutable/chunks/team-store.90511bc6.js","_app/immutable/chunks/fixture-store.724d0928.js","_app/immutable/chunks/player-store.1ed81bd6.js","_app/immutable/chunks/manager-store.9ce96d4b.js","_app/immutable/chunks/BadgeIcon.5f1570c4.js","_app/immutable/chunks/ShirtIcon.cbb688e3.js"];
export const stylesheets = ["_app/immutable/assets/9.69c14fad.css","_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
