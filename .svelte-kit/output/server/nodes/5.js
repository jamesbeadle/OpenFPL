

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.BxwQvZ3r.js","_app/immutable/chunks/index.BxUunZD3.js","_app/immutable/chunks/vendor.B9WuweXS.js"];
export const stylesheets = ["_app/immutable/assets/index.Rv2hwZu0.css"];
export const fonts = [];
