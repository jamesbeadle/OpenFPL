

export const index = 3;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-fixture-data/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/3.92069d17.js","_app/immutable/chunks/index.75721ab1.js","_app/immutable/chunks/vendor.f94f75d9.js"];
export const stylesheets = ["_app/immutable/assets/index.87959933.css"];
export const fonts = [];
