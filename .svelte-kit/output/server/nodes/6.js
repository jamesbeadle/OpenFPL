

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/fixture-validation/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.64e23464.js","_app/immutable/chunks/index.2bf26824.js","_app/immutable/chunks/vendor.4567b5a3.js"];
export const stylesheets = ["_app/immutable/assets/index.5b660869.css"];
export const fonts = [];
