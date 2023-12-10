

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.52a3c59c.js","_app/immutable/chunks/index.cb1fafc0.js","_app/immutable/chunks/vendor.8b9fb4dc.js"];
export const stylesheets = ["_app/immutable/assets/index.a380b529.css"];
export const fonts = [];
