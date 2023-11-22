

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.f93314b4.js","_app/immutable/chunks/index.878abf19.js","_app/immutable/chunks/Layout.987d9cae.js","_app/immutable/chunks/stores.8fa21572.js","_app/immutable/chunks/singletons.6a8625ca.js","_app/immutable/chunks/preload-helper.a4192956.js","_app/immutable/chunks/LoadingIcon.ca18fd8e.js"];
export const stylesheets = ["_app/immutable/assets/9.f774a8e5.css","_app/immutable/assets/Layout.1525f4bf.css","_app/immutable/assets/LoadingIcon.2aedc414.css"];
export const fonts = [];
