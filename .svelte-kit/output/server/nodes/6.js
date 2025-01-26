

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.X5OPe1Jh.js","_app/immutable/chunks/index.DuAglEVb.js","_app/immutable/chunks/vendor.hUSe3yth.js"];
export const stylesheets = ["_app/immutable/assets/index.BnVD0ddi.css"];
export const fonts = [];
