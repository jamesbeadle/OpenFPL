

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/profile/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.1e1ef0d3.js","_app/immutable/chunks/index.7fcbe5f0.js","_app/immutable/chunks/vendor.6c5fdda1.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
