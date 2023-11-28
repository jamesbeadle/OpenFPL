

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.6984796c.js","_app/immutable/chunks/index.c7b38e5e.js","_app/immutable/chunks/Layout.a0c76cdc.js","_app/immutable/chunks/index.8caf67b2.js","_app/immutable/chunks/stores.46fe71ba.js","_app/immutable/chunks/singletons.095fe9e5.js","_app/immutable/chunks/toast-store.6633d9f4.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/6.b3013d1d.css","_app/immutable/assets/Layout.1b44d07a.css"];
export const fonts = [];
