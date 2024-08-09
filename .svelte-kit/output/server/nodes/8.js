

export const index = 8;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/gameplay-rules/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/8.l-Of0maO.js","_app/immutable/chunks/index.g25y5VOZ.js","_app/immutable/chunks/vendor.GTZ3lRDl.js"];
export const stylesheets = ["_app/immutable/assets/index.2U5fRpra.css"];
export const fonts = [];
