

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.1f9c950c.js","_app/immutable/chunks/index.8b2af826.js","_app/immutable/chunks/vendor.909caab4.js"];
export const stylesheets = ["_app/immutable/assets/index.a380b529.css"];
export const fonts = [];
