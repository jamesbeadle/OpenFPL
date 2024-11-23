

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.BKXbPQOD.js","_app/immutable/chunks/index.BxUunZD3.js","_app/immutable/chunks/vendor.B9WuweXS.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
