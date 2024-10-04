

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.CCAAzyO0.js","_app/immutable/chunks/index.BG1BOtU1.js","_app/immutable/chunks/vendor.1capJgBY.js"];
export const stylesheets = ["_app/immutable/assets/index.DmXMtCUP.css"];
export const fonts = [];
