

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.179384c6.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/stores.68a73d15.js","_app/immutable/chunks/singletons.94507497.js","_app/immutable/chunks/Layout.b1215686.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
