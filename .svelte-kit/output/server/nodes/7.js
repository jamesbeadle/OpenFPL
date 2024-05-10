

export const index = 7;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/7.rzjPzFBZ.js","_app/immutable/chunks/index.DA-gvvwy.js","_app/immutable/chunks/vendor.B3-IAL51.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
