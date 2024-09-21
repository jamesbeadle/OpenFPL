

export const index = 14;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/14.x001CxUE.js","_app/immutable/chunks/index.5KQ245YH.js","_app/immutable/chunks/vendor.-WrtZipv.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
