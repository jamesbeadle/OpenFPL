

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.e9184f04.js","_app/immutable/chunks/index.983a729b.js","_app/immutable/chunks/vendor.4f7561fe.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
