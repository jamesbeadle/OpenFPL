

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.DYO0gixM.js","_app/immutable/chunks/index.FON_zxSC.js","_app/immutable/chunks/vendor.BXX-5rrL.js"];
export const stylesheets = ["_app/immutable/assets/index.Fy5pTVVK.css"];
export const fonts = [];
