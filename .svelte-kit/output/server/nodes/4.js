

export const index = 4;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/4.BARH_hlY.js","_app/immutable/chunks/index.CnfouH-G.js","_app/immutable/chunks/vendor.B9uk1_6A.js"];
export const stylesheets = ["_app/immutable/assets/index.Cd9SHXD-.css"];
export const fonts = [];
