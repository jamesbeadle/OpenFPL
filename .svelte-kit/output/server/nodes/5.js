

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.0b87f2d1.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/team-store.f070e8c0.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/Helpers.c6feb0fc.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/fixture-store.89aff47d.js","_app/immutable/chunks/player-store.a104f370.js","_app/immutable/chunks/system-store.53911b2c.js","_app/immutable/chunks/Layout.1bcae1a2.js","_app/immutable/chunks/stores.d5870709.js","_app/immutable/chunks/singletons.2804915a.js","_app/immutable/chunks/BadgeIcon.aeacabbb.js","_app/immutable/chunks/ShirtIcon.b29a0cee.js"];
export const stylesheets = ["_app/immutable/assets/Layout.c34298fa.css"];
export const fonts = [];
