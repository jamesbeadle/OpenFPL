

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.073d4944.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.a9f87d98.js","_app/immutable/chunks/singletons.bce1901b.js","_app/immutable/chunks/stores.f797788d.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/manager-gameweeks.9516bde9.js","_app/immutable/chunks/manager-store.8236494f.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js"];
export const stylesheets = ["_app/immutable/assets/12.1aed53fb.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
