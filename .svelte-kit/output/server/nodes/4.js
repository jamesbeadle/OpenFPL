

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.f976c6f9.js","_app/immutable/chunks/index.aa733771.js","_app/immutable/chunks/LoadingIcon.b1900f5b.js","_app/immutable/chunks/Layout.79823031.js","_app/immutable/chunks/stores.897bcf18.js","_app/immutable/chunks/singletons.1877a767.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/TeamService.7d253bbd.js"];
export const stylesheets = ["_app/immutable/assets/4.42acbe7e.css","_app/immutable/assets/LoadingIcon.2aedc414.css","_app/immutable/assets/Layout.679ed808.css"];
export const fonts = [];
