

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.7203264a.js","_app/immutable/chunks/index.245a0e92.js","_app/immutable/chunks/Layout.24679a1a.js","_app/immutable/chunks/index.c203a7c8.js","_app/immutable/chunks/stores.1b616741.js","_app/immutable/chunks/singletons.b097b3f7.js","_app/immutable/chunks/Helpers.5827f282.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/system-store.944c9f5b.js","_app/immutable/chunks/fixture-store.e0823489.js","_app/immutable/chunks/team-store.fd743fd2.js","_app/immutable/chunks/player-store.071c0cb1.js","_app/immutable/chunks/manager-store.717e10ee.js","_app/immutable/chunks/BadgeIcon.aeacabbb.js","_app/immutable/chunks/ShirtIcon.b29a0cee.js"];
export const stylesheets = ["_app/immutable/assets/9.69c14fad.css","_app/immutable/assets/Layout.c34298fa.css"];
export const fonts = [];
