

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.f2a2c2b3.js","_app/immutable/chunks/index.d2fad0ed.js","_app/immutable/chunks/vendor.69eaddaa.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
