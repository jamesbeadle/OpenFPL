

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.CX_2_kbU.js","_app/immutable/chunks/index.CdKtK5Xv.js","_app/immutable/chunks/vendor.Bd4fOVMp.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
