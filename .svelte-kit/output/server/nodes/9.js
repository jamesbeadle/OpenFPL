

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.483f238d.js","_app/immutable/chunks/index.2b3b4d26.js","_app/immutable/chunks/vendor.112b4cf9.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
