

export const index = 6;
let component_cache;
export const component = async () => component_cache ??= (await import('../entries/pages/manager/_page.svelte.js')).default;
export const imports = ["_app/immutable/nodes/6.DUPsH3p8.js","_app/immutable/chunks/index.DlgKAGeU.js","_app/immutable/chunks/vendor.DGWZq8v6.js"];
export const stylesheets = ["_app/immutable/assets/index.DI_gyc2R.css"];
export const fonts = [];
