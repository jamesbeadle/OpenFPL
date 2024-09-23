

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.n0ymAqHc.js","_app/immutable/chunks/index.VRTQNpQI.js","_app/immutable/chunks/vendor.7QIjtgAV.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
