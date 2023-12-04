

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.8a352f33.js","_app/immutable/chunks/index.9a5c8108.js","_app/immutable/chunks/vendor.44a0d7d0.js"];
export const stylesheets = ["_app/immutable/assets/index.5b660869.css"];
export const fonts = [];
