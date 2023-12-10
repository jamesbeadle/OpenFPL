

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.c091251b.js","_app/immutable/chunks/index.cb1fafc0.js","_app/immutable/chunks/vendor.8b9fb4dc.js"];
export const stylesheets = ["_app/immutable/assets/index.a380b529.css"];
export const fonts = [];
