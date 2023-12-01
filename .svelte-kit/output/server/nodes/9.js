

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.5cab66f3.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/Layout.d10cf2e0.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/stores.3a27911b.js","_app/immutable/chunks/singletons.76216e9a.js","_app/immutable/chunks/toast-store.0b82f89c.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/system-store.029b98ee.js","_app/immutable/chunks/team-store.b04b0b2e.js","_app/immutable/chunks/fixture-store.4a74b834.js","_app/immutable/chunks/player-store.4c8784c1.js","_app/immutable/chunks/manager-store.244c9f60.js","_app/immutable/chunks/BadgeIcon.aeacabbb.js","_app/immutable/chunks/ShirtIcon.b29a0cee.js"];
export const stylesheets = ["_app/immutable/assets/9.69c14fad.css","_app/immutable/assets/Layout.31940902.css"];
export const fonts = [];
