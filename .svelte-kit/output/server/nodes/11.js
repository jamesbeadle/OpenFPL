

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.uJx7kih_.js","_app/immutable/chunks/index.huGMpKYj.js","_app/immutable/chunks/vendor.hB46pdEq.js"];
export const stylesheets = ["_app/immutable/assets/index.LowOqC7e.css"];
export const fonts = [];
