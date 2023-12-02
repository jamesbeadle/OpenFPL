

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.afdbf56f.js","_app/immutable/chunks/index.a8c54947.js","_app/immutable/chunks/Layout.37f8df07.js","_app/immutable/chunks/singletons.7a3c8e4c.js","_app/immutable/chunks/stores.fa259919.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/7.2206b352.css","_app/immutable/assets/Layout.ef6abfb5.css"];
export const fonts = [];
