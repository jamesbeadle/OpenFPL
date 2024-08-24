

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.i0He6Wxw.js","_app/immutable/chunks/index.Rl0xEGcn.js","_app/immutable/chunks/vendor.Se8jChN-.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
