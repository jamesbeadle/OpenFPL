

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.495283a7.js","_app/immutable/chunks/index.cd1e0b3b.js","_app/immutable/chunks/vendor.f543769e.js"];
export const stylesheets = ["_app/immutable/assets/index.38c3479e.css"];
export const fonts = [];
