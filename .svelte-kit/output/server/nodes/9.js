

export const index = 9;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/9.f2h7MOpH.js","_app/immutable/chunks/index.37i_z9U9.js","_app/immutable/chunks/vendor.C1dDJ-bO.js"];
export const stylesheets = ["_app/immutable/assets/index.kq-AEiDT.css"];
export const fonts = [];
