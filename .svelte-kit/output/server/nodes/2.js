

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.ddd93ca3.js","_app/immutable/chunks/index.b324a1dd.js","_app/immutable/chunks/LoadingIcon.16560e32.js","_app/immutable/chunks/Layout.019a660d.js","_app/immutable/chunks/stores.912634c5.js","_app/immutable/chunks/singletons.0bb6c3a5.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/TeamService.d8b3ee2a.js","_app/immutable/chunks/ManagerService.abf61ef7.js"];
export const stylesheets = ["_app/immutable/assets/2.4d84599f.css","_app/immutable/assets/LoadingIcon.2aedc414.css","_app/immutable/assets/Layout.48a06658.css"];
export const fonts = [];
