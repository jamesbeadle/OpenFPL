

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.BAGMsq4v.js","_app/immutable/chunks/index.DfU5f7Rn.js","_app/immutable/chunks/vendor.LuhUQ0TS.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
