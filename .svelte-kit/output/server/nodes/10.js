

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.c5c3022b.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.b1215686.js","_app/immutable/chunks/singletons.94507497.js","_app/immutable/chunks/stores.68a73d15.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/manager-store.0fad03db.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/ShirtIcon.3da312bd.js"];
export const stylesheets = ["_app/immutable/assets/10.291f2ab9.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
