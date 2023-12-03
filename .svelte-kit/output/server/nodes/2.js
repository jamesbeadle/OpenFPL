

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.69fed022.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.a9f87d98.js","_app/immutable/chunks/singletons.bce1901b.js","_app/immutable/chunks/stores.f797788d.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/manager-store.8236494f.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js"];
export const stylesheets = ["_app/immutable/assets/2.cc11644e.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
