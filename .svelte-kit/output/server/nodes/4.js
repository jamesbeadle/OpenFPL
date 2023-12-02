

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.49484665.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/Layout.1bcae1a2.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/stores.d5870709.js","_app/immutable/chunks/singletons.2804915a.js","_app/immutable/chunks/Helpers.c6feb0fc.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/team-store.f070e8c0.js","_app/immutable/chunks/fixture-store.89aff47d.js","_app/immutable/chunks/system-store.53911b2c.js","_app/immutable/chunks/BadgeIcon.aeacabbb.js"];
export const stylesheets = ["_app/immutable/assets/Layout.c34298fa.css"];
export const fonts = [];
