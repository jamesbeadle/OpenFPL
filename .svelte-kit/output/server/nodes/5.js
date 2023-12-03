

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.d907552f.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.0e76e124.js","_app/immutable/chunks/singletons.fdfa7ed0.js","_app/immutable/chunks/stores.95126db5.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/ShirtIcon.3da312bd.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
