

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.8VLYB-lr.js","_app/immutable/chunks/index.TM3wnKZy.js","_app/immutable/chunks/vendor.G2rqpMx3.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
