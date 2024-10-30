

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/terms/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.DWKLy_uX.js","_app/immutable/chunks/index.DLadEFdq.js","_app/immutable/chunks/vendor.Dy2kZeTP.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
