

export const index = 10;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/league/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/10.TLNcitWF.js","_app/immutable/chunks/index.g25y5VOZ.js","_app/immutable/chunks/vendor.GTZ3lRDl.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
