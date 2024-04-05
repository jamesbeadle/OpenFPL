

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/clubs/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.CsPSppjD.js","_app/immutable/chunks/index.5MInz9wX.js","_app/immutable/chunks/vendor.CJMNsvCj.js"];
export const stylesheets = ["_app/immutable/assets/index.JxclgTL9.css"];
export const fonts = [];
