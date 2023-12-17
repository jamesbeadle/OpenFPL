

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.0dec2f39.js","_app/immutable/chunks/index.97ad1445.js","_app/immutable/chunks/vendor.fedbe501.js"];
export const stylesheets = ["_app/immutable/assets/index.ebf46584.css"];
export const fonts = [];
