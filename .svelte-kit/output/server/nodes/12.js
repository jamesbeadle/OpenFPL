

export const index = 12;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/12.BihaTS89.js","_app/immutable/chunks/index.FON_zxSC.js","_app/immutable/chunks/vendor.BXX-5rrL.js"];
export const stylesheets = ["_app/immutable/assets/index.Fy5pTVVK.css"];
export const fonts = [];
