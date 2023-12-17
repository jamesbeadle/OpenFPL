

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.9296d46a.js","_app/immutable/chunks/index.97ad1445.js","_app/immutable/chunks/vendor.fedbe501.js"];
export const stylesheets = ["_app/immutable/assets/index.ebf46584.css"];
export const fonts = [];
