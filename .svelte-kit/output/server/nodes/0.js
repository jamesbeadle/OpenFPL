

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.Z4Xv98Hh.js","_app/immutable/chunks/index.VRTQNpQI.js","_app/immutable/chunks/vendor.7QIjtgAV.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
