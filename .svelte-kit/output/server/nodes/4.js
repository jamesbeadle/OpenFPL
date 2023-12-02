

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.e10fae26.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.3f9368f3.js","_app/immutable/chunks/singletons.e655d5e5.js","_app/immutable/chunks/stores.42c5f1dc.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/team-store.583260fe.js","_app/immutable/chunks/fixture-store.880a736f.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
