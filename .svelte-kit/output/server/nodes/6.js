

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.P3GHmZJ-.js","_app/immutable/chunks/index.GPHRZn9m.js","_app/immutable/chunks/vendor.eeTTADQn.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
