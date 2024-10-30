

export const index = 1;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/error.svelte.js')).default;
export const imports = ["_app/immutable/nodes/1.mn1TbcVs.js","_app/immutable/chunks/index.DLadEFdq.js","_app/immutable/chunks/vendor.Dy2kZeTP.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
