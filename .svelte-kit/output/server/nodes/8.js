

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.dP5ptAZS.js","_app/immutable/chunks/index.Rl0xEGcn.js","_app/immutable/chunks/vendor.Se8jChN-.js"];
export const stylesheets = ["_app/immutable/assets/index.zEMMXcml.css"];
export const fonts = [];
