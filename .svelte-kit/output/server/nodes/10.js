

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.228bee08.js","_app/immutable/chunks/scheduler.2037d42e.js","_app/immutable/chunks/index.cd713282.js","_app/immutable/chunks/Layout.b983af79.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/singletons.4e632dcd.js","_app/immutable/chunks/stores.2a5d2c72.js","_app/immutable/chunks/manager-store.5e9e5c1f.js","_app/immutable/chunks/Modal.0b5343e4.js","_app/immutable/chunks/BadgeIcon.de5ce3c9.js","_app/immutable/chunks/LoadingIcon.64dacd79.js","_app/immutable/chunks/ShirtIcon.ede2fe7f.js"];
export const stylesheets = ["_app/immutable/assets/10.291f2ab9.css","_app/immutable/assets/Layout.9bede06c.css","_app/immutable/assets/LoadingIcon.d404a2c5.css"];
export const fonts = [];
