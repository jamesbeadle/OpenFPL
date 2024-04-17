

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.fbn8XCwc.js","_app/immutable/chunks/index.Y6f1pQlh.js","_app/immutable/chunks/vendor.AgI9z-mT.js"];
export const stylesheets = ["_app/immutable/assets/index.B4GYfJYv.css"];
export const fonts = [];
