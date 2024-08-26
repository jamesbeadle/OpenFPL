

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.5O4gQOw9.js","_app/immutable/chunks/index.GPHRZn9m.js","_app/immutable/chunks/vendor.eeTTADQn.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
