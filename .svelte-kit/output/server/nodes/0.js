

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.fpXaLleG.js","_app/immutable/chunks/index.DLadEFdq.js","_app/immutable/chunks/vendor.Dy2kZeTP.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
