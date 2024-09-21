

export const index = 13;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/pick-team/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/13.NUttEgSp.js","_app/immutable/chunks/index.xGaJXQWc.js","_app/immutable/chunks/vendor.YGDbZ-TQ.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
