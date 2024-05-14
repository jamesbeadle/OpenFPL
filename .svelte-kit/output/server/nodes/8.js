

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/governance/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.i5x412qN.js","_app/immutable/chunks/index.eq_SvWu6.js","_app/immutable/chunks/vendor.MT4N-lAz.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
