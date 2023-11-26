

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.e536b793.js","_app/immutable/chunks/index.dab0e011.js","_app/immutable/chunks/Layout.9d799e1b.js","_app/immutable/chunks/stores.1c99ebdd.js","_app/immutable/chunks/singletons.4559802b.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.e9874687.css"];
export const fonts = [];
