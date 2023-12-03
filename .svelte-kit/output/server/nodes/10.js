

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.4255ce37.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.1cdf6852.js","_app/immutable/chunks/singletons.08cdb953.js","_app/immutable/chunks/stores.032342f2.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/manager-store.cdcb2749.js","_app/immutable/chunks/BadgeIcon.ac2d82f5.js","_app/immutable/chunks/ShirtIcon.3da312bd.js"];
export const stylesheets = ["_app/immutable/assets/10.291f2ab9.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
