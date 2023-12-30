

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.0c4d6926.js","_app/immutable/chunks/index.016c417e.js","_app/immutable/chunks/vendor.1d8345db.js"];
export const stylesheets = ["_app/immutable/assets/index.74fe463c.css"];
export const fonts = [];
