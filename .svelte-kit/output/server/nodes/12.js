

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/my-leagues/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.A-_bSJfa.js","_app/immutable/chunks/index.TM3wnKZy.js","_app/immutable/chunks/vendor.G2rqpMx3.js"];
export const stylesheets = ["_app/immutable/assets/index.V62M-5SD.css"];
export const fonts = [];
