

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.c57f2c6b.js","_app/immutable/chunks/index.cd1dce0c.js","_app/immutable/chunks/vendor.1ae5dcba.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
