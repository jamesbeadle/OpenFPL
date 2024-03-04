

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.vvUWZOzA.js","_app/immutable/chunks/index.Ya9GbuY1.js","_app/immutable/chunks/vendor.HOizhr7_.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
