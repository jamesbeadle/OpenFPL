

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.863adcd3.js","_app/immutable/chunks/index.878abf19.js","_app/immutable/chunks/Layout.987d9cae.js","_app/immutable/chunks/stores.8fa21572.js","_app/immutable/chunks/singletons.6a8625ca.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.1525f4bf.css"];
export const fonts = [];
