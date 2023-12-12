

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.b90a3827.js","_app/immutable/chunks/index.518537fd.js","_app/immutable/chunks/vendor.1cf599bd.js"];
export const stylesheets = ["_app/immutable/assets/index.85ac9d40.css"];
export const fonts = [];
