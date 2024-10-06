

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.C_KP2jC_.js","_app/immutable/chunks/index.BZGYu6nJ.js","_app/immutable/chunks/vendor.17mBzHWC.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
