

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.24b755bb.js","_app/immutable/chunks/index.b324a1dd.js","_app/immutable/chunks/Layout.8d88a232.js","_app/immutable/chunks/stores.b64d190c.js","_app/immutable/chunks/singletons.ed5340ea.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/LoadingIcon.12f48f25.js","_app/immutable/chunks/TeamService.3585d717.js","_app/immutable/chunks/PlayerService.26447090.js"];
export const stylesheets = ["_app/immutable/assets/8.7515d509.css","_app/immutable/assets/Layout.48a06658.css","_app/immutable/assets/LoadingIcon.2aedc414.css"];
export const fonts = [];
