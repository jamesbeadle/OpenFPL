

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.b56839a7.js","_app/immutable/chunks/index.346e8282.js","_app/immutable/chunks/vendor.8a8fef42.js"];
export const stylesheets = ["_app/immutable/assets/index.71e058bb.css"];
export const fonts = [];
