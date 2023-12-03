

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.561ed280.js","_app/immutable/chunks/scheduler.2037d42e.js","_app/immutable/chunks/index.cd713282.js","_app/immutable/chunks/Layout.b983af79.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/singletons.4e632dcd.js","_app/immutable/chunks/stores.2a5d2c72.js"];
export const stylesheets = ["_app/immutable/assets/Layout.9bede06c.css"];
export const fonts = [];
