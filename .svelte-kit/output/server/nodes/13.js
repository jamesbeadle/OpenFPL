

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.N7c1ZdwX.js","_app/immutable/chunks/index.EtOeFP_1.js","_app/immutable/chunks/vendor.pa9Po0u-.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
