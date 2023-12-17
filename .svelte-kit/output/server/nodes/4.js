

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/admin/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.f0716b81.js","_app/immutable/chunks/index.97ad1445.js","_app/immutable/chunks/vendor.fedbe501.js"];
export const stylesheets = ["_app/immutable/assets/index.ebf46584.css"];
export const fonts = [];
