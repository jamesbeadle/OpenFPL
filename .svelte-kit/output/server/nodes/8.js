

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.aaf82a89.js","_app/immutable/chunks/index.346e8282.js","_app/immutable/chunks/vendor.8a8fef42.js"];
export const stylesheets = ["_app/immutable/assets/index.71e058bb.css"];
export const fonts = [];
