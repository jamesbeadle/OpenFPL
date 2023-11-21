

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.a5d74d5e.js","_app/immutable/chunks/index.b324a1dd.js","_app/immutable/chunks/Layout.019a660d.js","_app/immutable/chunks/stores.912634c5.js","_app/immutable/chunks/singletons.0bb6c3a5.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/5.b3013d1d.css","_app/immutable/assets/Layout.48a06658.css"];
export const fonts = [];
