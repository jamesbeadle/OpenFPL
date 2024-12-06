

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.C_iVN9mo.js","_app/immutable/chunks/index.CdKtK5Xv.js","_app/immutable/chunks/vendor.Bd4fOVMp.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
