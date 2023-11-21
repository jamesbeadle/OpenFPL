

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.42dc8c27.js","_app/immutable/chunks/index.b324a1dd.js","_app/immutable/chunks/Layout.019a660d.js","_app/immutable/chunks/stores.912634c5.js","_app/immutable/chunks/singletons.0bb6c3a5.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/LoadingIcon.16560e32.js","_app/immutable/chunks/TeamService.d8b3ee2a.js","_app/immutable/chunks/PlayerService.04d1c4fd.js"];
export const stylesheets = ["_app/immutable/assets/8.7515d509.css","_app/immutable/assets/Layout.48a06658.css","_app/immutable/assets/LoadingIcon.2aedc414.css"];
export const fonts = [];
