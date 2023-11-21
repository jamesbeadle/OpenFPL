

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.25c5abe6.js","_app/immutable/chunks/index.b324a1dd.js","_app/immutable/chunks/LoadingIcon.12f48f25.js","_app/immutable/chunks/Layout.8d88a232.js","_app/immutable/chunks/stores.b64d190c.js","_app/immutable/chunks/singletons.ed5340ea.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/TeamService.3585d717.js","_app/immutable/chunks/ManagerService.90ae0efb.js"];
export const stylesheets = ["_app/immutable/assets/2.4d84599f.css","_app/immutable/assets/LoadingIcon.2aedc414.css","_app/immutable/assets/Layout.48a06658.css"];
export const fonts = [];
