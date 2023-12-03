

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.eb1bc72d.js","_app/immutable/chunks/scheduler.2037d42e.js","_app/immutable/chunks/index.cd713282.js","_app/immutable/chunks/Layout.b983af79.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/singletons.4e632dcd.js","_app/immutable/chunks/stores.2a5d2c72.js","_app/immutable/chunks/LoadingIcon.64dacd79.js"];
export const stylesheets = ["_app/immutable/assets/Layout.9bede06c.css","_app/immutable/assets/LoadingIcon.d404a2c5.css"];
export const fonts = [];
