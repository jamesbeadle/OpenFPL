

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.CAjpTkW6.js","_app/immutable/chunks/index.rTZoIK3A.js","_app/immutable/chunks/vendor.GILRkgIM.js"];
export const stylesheets = ["_app/immutable/assets/index.T2MyJ15X.css"];
export const fonts = [];
