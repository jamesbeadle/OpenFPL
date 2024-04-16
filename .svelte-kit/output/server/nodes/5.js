

export const index = 5;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/club/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/5.Gx5aoUcE.js","_app/immutable/chunks/index.37i_z9U9.js","_app/immutable/chunks/vendor.C1dDJ-bO.js"];
export const stylesheets = ["_app/immutable/assets/index.kq-AEiDT.css"];
export const fonts = [];
