

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.wFgnx8He.js","_app/immutable/chunks/index.VRTQNpQI.js","_app/immutable/chunks/vendor.7QIjtgAV.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
