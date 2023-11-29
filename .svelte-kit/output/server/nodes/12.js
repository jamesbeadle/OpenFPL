

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.861b7e55.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/Layout.39e2a716.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/stores.f0f38284.js","_app/immutable/chunks/singletons.f40d3e23.js","_app/immutable/chunks/toast-store.64ad2768.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.1b44d07a.css"];
export const fonts = [];
