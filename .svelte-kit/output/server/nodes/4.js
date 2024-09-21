

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/add-proposal/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.qNVlsXeX.js","_app/immutable/chunks/index.5KQ245YH.js","_app/immutable/chunks/vendor.-WrtZipv.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
