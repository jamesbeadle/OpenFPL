

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.a0zbDrWn.js","_app/immutable/chunks/index.BZGYu6nJ.js","_app/immutable/chunks/vendor.17mBzHWC.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
