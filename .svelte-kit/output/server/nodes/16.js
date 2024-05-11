

export const index = 16;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/whitepaper/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/16.bhWeHLeg.js","_app/immutable/chunks/index.xMNskjAN.js","_app/immutable/chunks/vendor.DOxKcT2h.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
