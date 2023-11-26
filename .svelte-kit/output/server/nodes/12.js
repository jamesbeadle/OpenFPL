

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.3a28161e.js","_app/immutable/chunks/index.dab0e011.js","_app/immutable/chunks/Layout.9d799e1b.js","_app/immutable/chunks/stores.1c99ebdd.js","_app/immutable/chunks/singletons.4559802b.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/5.b3013d1d.css","_app/immutable/assets/Layout.e9874687.css"];
export const fonts = [];
