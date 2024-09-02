

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/status/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.sf2CCr6l.js","_app/immutable/chunks/index.TM3wnKZy.js","_app/immutable/chunks/vendor.G2rqpMx3.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
