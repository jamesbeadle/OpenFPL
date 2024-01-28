

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.1578c7b9.js","_app/immutable/chunks/index.983a729b.js","_app/immutable/chunks/vendor.4f7561fe.js"];
export const stylesheets = ["_app/immutable/assets/index.28121524.css"];
export const fonts = [];
