

export const index = 0;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/fallbacks/layout.svelte.js')).default;
export const imports = ["_app/immutable/nodes/0.ykKTj4jf.js","_app/immutable/chunks/index.5MInz9wX.js","_app/immutable/chunks/vendor.CJMNsvCj.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
