

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.3f74fb56.js","_app/immutable/chunks/index.b324a1dd.js","_app/immutable/chunks/TeamService.d8b3ee2a.js","_app/immutable/chunks/Layout.019a660d.js","_app/immutable/chunks/stores.912634c5.js","_app/immutable/chunks/singletons.0bb6c3a5.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/9.f774a8e5.css","_app/immutable/assets/Layout.48a06658.css"];
export const fonts = [];
