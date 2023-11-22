

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.a08f46e0.js","_app/immutable/chunks/index.878abf19.js","_app/immutable/chunks/Layout.987d9cae.js","_app/immutable/chunks/stores.8fa21572.js","_app/immutable/chunks/singletons.6a8625ca.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/LoadingIcon.ca18fd8e.js","_app/immutable/chunks/BadgeIcon.15c5bab3.js","_app/immutable/chunks/ShirtIcon.55a7ffc0.js","_app/immutable/chunks/PlayerService.54ce1220.js"];
export const stylesheets = ["_app/immutable/assets/8.7515d509.css","_app/immutable/assets/Layout.1525f4bf.css","_app/immutable/assets/LoadingIcon.2aedc414.css"];
export const fonts = [];
