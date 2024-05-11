

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.h4eBqeST.js","_app/immutable/chunks/index.xMNskjAN.js","_app/immutable/chunks/vendor.DOxKcT2h.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
