

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.U0PxbKZ8.js","_app/immutable/chunks/index.eq_SvWu6.js","_app/immutable/chunks/vendor.MT4N-lAz.js"];
export const stylesheets = ["_app/immutable/assets/index.us-fJLIm.css"];
export const fonts = [];
