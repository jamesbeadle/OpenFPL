

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.EWsX9-3L.js","_app/immutable/chunks/index.EtOeFP_1.js","_app/immutable/chunks/vendor.pa9Po0u-.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
