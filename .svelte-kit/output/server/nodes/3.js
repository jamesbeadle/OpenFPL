

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.c00f6588.js","_app/immutable/chunks/index.af4712d6.js","_app/immutable/chunks/vendor.8ee4eaca.js"];
export const stylesheets = ["_app/immutable/assets/index.b96eeb27.css"];
export const fonts = [];
