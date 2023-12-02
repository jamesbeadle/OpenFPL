

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.8aee72d8.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.3f9368f3.js","_app/immutable/chunks/singletons.e655d5e5.js","_app/immutable/chunks/stores.42c5f1dc.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/team-store.583260fe.js","_app/immutable/chunks/fixture-store.880a736f.js","_app/immutable/chunks/player-store.f12f3662.js","_app/immutable/chunks/manager-store.58773d0c.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/ShirtIcon.3da312bd.js"];
export const stylesheets = ["_app/immutable/assets/10.291f2ab9.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
