

export const index = 11;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/player/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/11.AJTbUI-e.js","_app/immutable/chunks/index.5MInz9wX.js","_app/immutable/chunks/vendor.CJMNsvCj.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
