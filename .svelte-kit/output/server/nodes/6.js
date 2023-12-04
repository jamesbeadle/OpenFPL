

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.b2cb6baf.js","_app/immutable/chunks/index.f6aa8908.js","_app/immutable/chunks/vendor.0a97e0bc.js"];
export const stylesheets = ["_app/immutable/assets/index.99ad048d.css"];
export const fonts = [];
