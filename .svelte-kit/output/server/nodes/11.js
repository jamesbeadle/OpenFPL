

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.0f064a4a.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.95126db5.js","_app/immutable/chunks/singletons.fdfa7ed0.js","_app/immutable/chunks/Layout.0e76e124.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/ViewDetailsIcon.d864d339.js","_app/immutable/chunks/ShirtIcon.3da312bd.js"];
export const stylesheets = ["_app/immutable/assets/11.ff16016e.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
