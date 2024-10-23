

export const index = 2;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/2.CiNt_rM5.js","_app/immutable/chunks/index.DfU5f7Rn.js","_app/immutable/chunks/vendor.LuhUQ0TS.js"];
export const stylesheets = ["_app/immutable/assets/index.BrcfK0HS.css"];
export const fonts = [];
