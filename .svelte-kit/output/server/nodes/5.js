

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.55a851ed.js","_app/immutable/chunks/index.e590a2b1.js","_app/immutable/chunks/Layout.021a5afb.js","_app/immutable/chunks/stores.ed880ce1.js","_app/immutable/chunks/singletons.2158a4f8.js","_app/immutable/chunks/preload-helper.a4192956.js"];
export const stylesheets = ["_app/immutable/assets/Layout.e0489d13.css"];
export const fonts = [];
