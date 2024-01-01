

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.b3fd5d67.js","_app/immutable/chunks/index.703f9152.js","_app/immutable/chunks/vendor.344be197.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
