

export const index = 14;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/14.ded1c3d8.js","_app/immutable/chunks/index.703f9152.js","_app/immutable/chunks/vendor.344be197.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
